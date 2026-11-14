"
Unit and integration tests for shared Git workflow orchestration, form persistence, error formatting, and commands.
"
Class {
	#name : 'OPGitTest',
	#superclass : 'TestCase',
	#instVars : [
		'server'
	],
	#category : 'OpenPonk-Git-Tests-Client',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'Client'
}

{ #category : 'running' }
OPGitTest >> tearDown [
	server ifNotNil: [ server stop ].
	OPGHAuthor deleteSavedInstance.
	OPGHCommit deleteSavedInstance.
	OPGHCredentials deleteSavedInstance.
	super tearDown
]

{ #category : 'tests' }
OPGitTest >> testCommandHierarchyAndMenuGroupMetadata [
	| menuGroup projectController mockWorkbench editorWithoutDiagram editorWithDiagram |
	self assert: OPGitCommand isAbstract description: 'OPGitCommand must be abstract'.
	self deny: OPGitUploadToGitHubCommand isAbstract description: 'Concrete command must not be abstract'.

	menuGroup := OPGitMenuGroup new.
	self assert: menuGroup name equals: 'Git model repository'.
	self assert: menuGroup order equals: 40.
	self assert: menuGroup icon isNotNil description: 'Git menu group must provide an icon'.

	projectController := OPProjectController forProject: OPProject new.
	mockWorkbench := Mock new.
	mockWorkbench stub projectController willReturn: projectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	mockWorkbench stub announcer willReturn: Announcer new.

	editorWithoutDiagram := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.
	self deny: (OPGitUploadToGitHubCommand canBeExecutedInEditor: editorWithoutDiagram) description: 'Command must not be executable without diagram controller'.

	editorWithDiagram := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.
	editorWithDiagram openEmptyModel: OPTestContainerModel new.
	self assert: (OPGitUploadToGitHubCommand canBeExecutedInEditor: editorWithDiagram) description: 'Command must be executable with diagram controller'.
	self assert: (OPGitDownloadFromGitHubCommand canBeExecutedInEditor: editorWithDiagram) description: 'GitHub download must be executable'.
	self assert: (OPGitUploadToGitLabCommand canBeExecutedInEditor: editorWithDiagram) description: 'GitLab upload must be executable'.
	self assert: (OPGitDownloadFromGitLabCommand canBeExecutedInEditor: editorWithDiagram) description: 'GitLab download must be executable'
]

{ #category : 'tests' }
OPGitTest >> testDirectorySelectedOpensFetchedProjectFiles [
	| tempDir sourceOppFile oppBytes gitClient openedControllers testWindowsBefore |
	tempDir := FileLocator temp / ('openponk-git-test-' , UUID new asString).
	tempDir ensureCreateDirectory.
	testWindowsBefore := (self currentWorld submorphs select: [ :m | m isSystemWindow ]) asIdentitySet.
	openedControllers := #().
	[
		sourceOppFile := tempDir / 'source.opp'.
		(OPProjectController forProject: (OPProject name: 'FetchedProject')) saveProjectTo: sourceOppFile.
		oppBytes := sourceOppFile binaryReadStreamDo: [ :s | s upToEnd ].
		sourceOppFile ensureDelete.

		server := ZnServer startOn: 0.
		server onRequestRespond: [ :request |
			| uri |
			uri := request uri pathPrintString.
			(uri endsWith: '/branches/main')
				ifTrue: [ ZnResponse ok: (ZnEntity json: '{"commit":{"sha":"c1"}}') ]
				ifFalse: [
					(uri endsWith: '/git/commits/c1')
						ifTrue: [ ZnResponse ok: (ZnEntity json: '{"tree":{"sha":"t1"}}') ]
						ifFalse: [
							(uri endsWith: '/git/trees/t1')
								ifTrue: [ ZnResponse ok: (ZnEntity json: '{"tree":[{"path":"fetched.opp","sha":"b1"}]}') ]
								ifFalse: [ ZnResponse ok: (ZnEntity json: '{"encoding":"base64","content":"' , oppBytes base64Encoded , '"}') ] ] ] ].

		gitClient := OPGitHub new.
		gitClient credentials token: 'tok'.
		gitClient commit
			repository: 'openponk/test';
			branch: 'main'.
		gitClient stub apiURL willReturn: 'http://localhost:' , server port asString.
		gitClient whenFinishedDo: [ :controllers | openedControllers := controllers ].

		gitClient directorySelected: tempDir pathString.

		self assert: openedControllers size equals: 1.
		self assert: openedControllers first project name equals: 'FetchedProject'
	] ensure: [
		((self currentWorld submorphs select: [ :m | m isSystemWindow ])
			reject: [ :m | testWindowsBefore includes: m ]) do: [ :w | w close ].
		tempDir ensureDeleteAll ]
]

{ #category : 'tests' }
OPGitTest >> testErrorFromMissingFormatsMessages [
	| gitClient |
	gitClient := OPGitHub new.

	self
		should: [ gitClient errorFrom: Dictionary new missing: 'tree' ]
		raise: Error
		withExceptionDo: [ :ex |
			self assert: ex messageText equals: 'GitHub server did not return "tree" property as part of the response' ].

	self
		should: [ gitClient errorFrom: { #message -> 'Not Found' } asDictionary missing: 'commit' ]
		raise: Error
		withExceptionDo: [ :ex |
			self assert: ex messageText equals: 'Not Found. Git repository does not exist or your access token is invalid.' ]
]

{ #category : 'tests' }
OPGitTest >> testFindAuthorAndProceedResolvesUserAndFallbackEmail [
	| dummyProjectController dummyCanvas gitClient persistedAuthor |
	dummyProjectController := Object new.
	dummyCanvas := Object new.

	server := ZnServer startOn: 0.
	server onRequestRespond: [ :request |
		(request uri pathPrintString endsWith: '/user/emails')
			ifTrue: [ ZnResponse ok: (ZnEntity json: '[{"email":"dev@openponk.org"}]') ]
			ifFalse: [ ZnResponse ok: (ZnEntity json: '{"name":"Ada Lovelace","email":null}') ] ].

	gitClient := OPGitHub new.
	gitClient credentials token: 'tok'.
	gitClient project: dummyProjectController.
	gitClient diagram: dummyCanvas.
	gitClient stub apiURL willReturn: 'http://localhost:' , server port asString.
	(gitClient stub commitChangesForProject: dummyProjectController withDiagram: dummyCanvas) willReturn: nil.

	gitClient findAuthorAndProceed.
	persistedAuthor := gitClient author.
	self assert: persistedAuthor name equals: 'Ada Lovelace'.
	self assert: persistedAuthor email equals: 'dev@openponk.org'.

	server onRequestRespond: [ :request |
		ZnResponse ok: (ZnEntity json: '{"name":null,"email":"ada@openponk.org"}') ].
	self should: [ gitClient findAuthorAndProceed ] raise: Error
]

{ #category : 'tests' }
OPGitTest >> testRepositoryFilledPersistsOrClearsSingletons [
	| gitClient commitUI fetchTriggered commitTriggered |
	gitClient := OPGitHub new.
	commitUI := OPGitCommitUI newApplication: SpApplication defaultApplication.
	commitUI build.
	commitUI textToken text: 'secret-tok'.
	commitUI textRepository text: 'openponk/demo'.
	commitUI textBranch text: 'dev'.
	commitUI textMsg text: 'Save changes'.
	commitUI checkBoxSave state: true.

	commitTriggered := false.
	gitClient stub findAuthorAndProceed will: [ commitTriggered := true ].
	gitClient commitSet: commitUI.

	self assert: commitTriggered description: 'commitSet: must trigger author resolution'.
	self assert: gitClient commit message equals: 'Save changes'.
	self assert: OPGHCredentials savedInstance token equals: 'secret-tok'.
	self assert: OPGHCommit savedInstance repository equals: 'openponk/demo'.
	self assert: OPGHCommit savedInstance branch equals: 'dev'.

	commitUI checkBoxSave state: false.
	fetchTriggered := false.
	gitClient stub showDirectoryDialog will: [ fetchTriggered := true ].
	gitClient fetchRepositoryFilled: commitUI.

	self assert: fetchTriggered description: 'fetchRepositoryFilled: must open directory dialog'.
	self assert: OPGHCredentials savedInstance identicalTo: nil.
	self assert: OPGHCommit savedInstance identicalTo: nil
]
