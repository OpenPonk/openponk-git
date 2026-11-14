"
Integration tests for GitLab REST API client workflows against a local HTTP server.
"
Class {
	#name : 'OPGitLabTest',
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
OPGitLabTest >> baseUrl [
	^ 'http://localhost:' , server port asString
]

{ #category : 'running' }
OPGitLabTest >> setUp [
	super setUp.
	OPGHAuthor deleteSavedInstance.
	OPGHCommit deleteSavedInstance.
	OPGHCredentials deleteSavedInstance.
	server := ZnServer startOn: 0.
	client := OPGitLab new.
	client credentials token: 'glpat-testtoken'.
	client commit
		repository: 'group/project';
		branch: 'main';
		message: 'Update model'.
	client author
		name: 'GitLab User';
		email: 'gl@example.com'
]

{ #category : 'running' }
OPGitLabTest >> tearDown [
	server ifNotNil: [ server stop ].
	OPGHAuthor deleteSavedInstance.
	OPGHCommit deleteSavedInstance.
	OPGHCredentials deleteSavedInstance.
	super tearDown
]

{ #category : 'tests' }
OPGitLabTest >> testCommitChangesBuildsCreateAndUpdateActions [

	| memDir oppFile pngFile postedCommitBody parsedPayload actions actionsByPath commitSha |
	memDir := FileSystem memory root / 'gl-commit'.
	memDir ensureCreateDirectory.
	oppFile := memDir / 'model.opp'.
	pngFile := memDir / 'model.png'.
	oppFile writeStreamDo: [ :s | s nextPutAll: 'OPP' ].
	pngFile writeStreamDo: [ :s | s nextPutAll: 'PNG' ].

	postedCommitBody := nil.
	server onRequestRespond: [ :request |
			| uri |
			uri := request uri pathPrintString.
			(uri endsWith: '/tree')
				ifTrue: [ ZnResponse ok: (ZnEntity json: '[{"path":"model.opp","type":"blob","id":"sha1"}]') ]
				ifFalse: [
						(uri endsWith: '/branches/main')
							ifTrue: [ ZnResponse ok: (ZnEntity json: '{"commit":{"id":"last_gl_sha"}}') ]
							ifFalse: [
									postedCommitBody := request entity contents.
									ZnResponse ok: (ZnEntity json: '{"id":"new_gl_commit"}') ] ] ].

	client stub apiURL willReturn: self baseUrl.
	commitSha := client commitChangesFor: {
			             (OPGHFile withPath: 'model.opp' file: oppFile).
			             (OPGHFile withPath: 'model.png' file: pngFile) }.

	self assert: commitSha equals: 'new_gl_commit'.
	parsedPayload := NeoJSONReader fromString: postedCommitBody.
	actions := parsedPayload at: 'actions'.
	actionsByPath := (actions collect: [ :each | (each at: 'file_path') -> (each at: 'action') ]) asDictionary.
	self assert: (actionsByPath at: 'model.opp') equals: 'update'.
	self assert: (actionsByPath at: 'model.png') equals: 'create'
]

{ #category : 'tests' }
OPGitLabTest >> testDomainUrlsAndAuthorEmailResolution [
	self assert: client apiDomain equals: 'gitlab.com'.
	self assert: client apiURL equals: 'https://gitlab.com/api/v4'.
	client apiDomain: 'gitlab.fit.cvut.cz'.
	self assert: client apiName equals: 'gitlab.fit.cvut.cz'.
	self assert: client apiURL equals: 'https://gitlab.fit.cvut.cz/api/v4'.

	server onRequestRespond: [ :request |
		ZnResponse ok: (ZnEntity json: '[{"email":"secondary@example.com","primary":false,"verified":true},{"email":"primary@example.com","primary":true,"verified":true}]') ].
	client stub apiURL willReturn: self baseUrl.
	self assert: client getAuthorEmail equals: 'primary@example.com'
]

{ #category : 'tests' }
OPGitLabTest >> testEmptyRepositoryActionsAndErrorResponses [
	| memDir oppFile actions |
	memDir := FileSystem memory root / 'gl-empty'.
	memDir ensureCreateDirectory.
	oppFile := memDir / 'new_model.opp'.
	oppFile writeStreamDo: [ :s | s nextPutAll: 'NEW_OPP' ].

	server onRequestRespond: [ :request |
		ZnResponse ok: (ZnEntity json: '[]') ].
	client stub apiURL willReturn: self baseUrl.

	self should: [ client getRepoItems ] raise: OPGHModelDoesNotExist.

	actions := client getActionsToPostFiles: { OPGHFile withPath: 'new_model.opp' file: oppFile } withCommitSha: 'sha0'.
	self assert: actions size equals: 1.
	self assert: (actions first at: 'action') equals: 'create'.

	server onRequestRespond: [ :request |
		ZnResponse notFound: request uri ].
	self should: [ client getRepoItems ] raise: Error
]
