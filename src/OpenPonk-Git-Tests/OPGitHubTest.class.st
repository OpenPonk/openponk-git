"
Integration tests for GitHub REST API client workflows against a local HTTP server.
"
Class {
	#name : 'OPGitHubTest',
	#superclass : 'TestCase',
	#instVars : [
		'server',
		'client'
	],
	#category : 'OpenPonk-Git-Tests-Client',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'Client'
}

{ #category : 'private' }
OPGitHubTest >> baseUrl [
	^ 'http://localhost:' , server port asString
]

{ #category : 'running' }
OPGitHubTest >> setUp [
	super setUp.
	OPGHAuthor deleteSavedInstance.
	OPGHCommit deleteSavedInstance.
	OPGHCredentials deleteSavedInstance.
	server := ZnServer startOn: 0.
	client := OPGitHub new.
	client credentials token: 'ghp_testtoken'.
	client commit
		repository: 'openponk/test-repo';
		branch: 'main';
		message: 'Save diagram'.
	client author
		name: 'Test User';
		email: 'test@example.com'
]

{ #category : 'running' }
OPGitHubTest >> tearDown [
	server ifNotNil: [ server stop ].
	OPGHAuthor deleteSavedInstance.
	OPGHCommit deleteSavedInstance.
	OPGHCredentials deleteSavedInstance.
	super tearDown
]

{ #category : 'tests' }
OPGitHubTest >> testCommitChangesUploadsDistinctProjectAndPngFiles [
	| memDir projectFile pngFile mockProjectController mockProject mockCanvas uploadedPayloads finishedFiles |
	memDir := FileSystem memory root / 'gh-commit'.
	memDir ensureCreateDirectory.
	projectFile := memDir / 'demo.opp'.
	pngFile := memDir / 'demo.png'.
	projectFile writeStreamDo: [ :s | s nextPutAll: 'PROJECT_BYTES' ].
	pngFile writeStreamDo: [ :s | s nextPutAll: 'PNG_BYTES' ].

	uploadedPayloads := OrderedCollection new.
	server onRequestRespond: [ :request |
		| uri |
		uri := request uri pathPrintString.
		(uri endsWith: '/git/blobs')
			ifTrue: [
				uploadedPayloads add: request entity contents.
				ZnResponse ok: (ZnEntity json: '{"sha":"blob_sha_' , uploadedPayloads size asString , '"}') ]
			ifFalse: [
				(uri endsWith: '/branches/main')
					ifTrue: [ ZnResponse ok: (ZnEntity json: '{"commit":{"sha":"head_sha"}}') ]
					ifFalse: [
						(uri endsWith: '/git/trees')
							ifTrue: [ ZnResponse ok: (ZnEntity json: '{"sha":"new_tree_sha"}') ]
							ifFalse: [
								(uri endsWith: '/git/commits')
									ifTrue: [ ZnResponse ok: (ZnEntity json: '{"sha":"new_commit_sha"}') ]
									ifFalse: [ ZnResponse ok: (ZnEntity json: '{"ref":"refs/heads/main"}') ] ] ] ] ].

	mockProject := Mock new.
	mockProject stub storageFile willReturn: projectFile.
	mockProjectController := Mock new.
	mockProjectController stub saveProject.
	mockProjectController stub project willReturn: mockProject.
	mockCanvas := Mock new.
	mockCanvas stub exportAsPng: pngFile.

	client stub apiURL willReturn: self baseUrl.
	finishedFiles := nil.
	client whenFinishedDo: [ :files | finishedFiles := files ].
	client commitChangesForProject: mockProjectController withDiagram: mockCanvas.

	self assert: uploadedPayloads size equals: 2.
	self assert: (uploadedPayloads first includesSubstring: 'PROJECT_BYTES' utf8Encoded base64Encoded) description: 'First blob must contain project file content'.
	self assert: (uploadedPayloads second includesSubstring: 'PNG_BYTES' utf8Encoded base64Encoded) description: 'Second blob must contain PNG file content'.
	self assertCollection: finishedFiles hasSameElements: { projectFile . pngFile }
]

{ #category : 'tests' }
OPGitHubTest >> testFetchAndSaveProjectFiles [
	| memDir savedPaths |
	server onRequestRespond: [ :request |
		| uri |
		uri := request uri pathPrintString.
		(uri endsWith: '/branches/main')
			ifTrue: [ ZnResponse ok: (ZnEntity json: '{"commit":{"sha":"commit123"}}') ]
			ifFalse: [
				(uri endsWith: '/git/commits/commit123')
					ifTrue: [ ZnResponse ok: (ZnEntity json: '{"tree":{"sha":"tree456"}}') ]
					ifFalse: [
						(uri endsWith: '/git/trees/tree456')
							ifTrue: [ ZnResponse ok: (ZnEntity json: '{"tree":[{"path":"model.opp","sha":"blob1"},{"path":"diagram.png","sha":"blob2"},{"path":"README.md","sha":"blob3"}]}') ]
							ifFalse: [
								(uri endsWith: '/git/blobs/blob1')
									ifTrue: [ ZnResponse ok: (ZnEntity json: '{"encoding":"base64","content":"' , 'OPP_DATA' utf8Encoded base64Encoded , '"}') ]
									ifFalse: [ ZnResponse ok: (ZnEntity json: '{"encoding":"base64","content":"' , 'PNG_DATA' utf8Encoded base64Encoded , '"}') ] ] ] ] ].

	client stub apiURL willReturn: self baseUrl.
	memDir := FileSystem memory root / 'gh-fetch'.
	savedPaths := client fetchProjectAndSaveItTo: memDir.

	self assert: savedPaths size equals: 2.
	self assert: (memDir / 'model.opp') contents equals: 'OPP_DATA'.
	self assert: (memDir / 'diagram.png') contents equals: 'PNG_DATA'.
	self deny: (memDir / 'README.md') exists description: 'Non-project files must be filtered out'
]
