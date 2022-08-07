Class {
	#name : #OpenPonkGit,
	#superclass : #Object,
	#instVars : [
		'author',
		'credentials',
		'commit',
		'project',
		'diagram'
	],
	#category : #'OpenPonk-Git'
}

{ #category : #initialization }
OpenPonkGit class >> withProject: aProjectController withDiagram: aCanvasModel [
	| instance |
	instance := self new.
	instance project: aProjectController.
	instance diagram: aCanvasModel.
	^ instance.
]

{ #category : #adding }
OpenPonkGit >> addTokenTo: client [

	self subclassResponsibility
]

{ #category : #'constants - url' }
OpenPonkGit >> apiURL [

	^ self subclassResponsibility
]

{ #category : #accessing }
OpenPonkGit >> author [ 
	^ author.
]

{ #category : #accessing }
OpenPonkGit >> author: aAuthor [
	author := aAuthor.
]

{ #category : #'commit-process' }
OpenPonkGit >> authorSet: aForm [
	author name: aForm textName text.
	author email: aForm textEmail text.
	aForm checkBoxSave state ifFalse: [ OPGHAuthor deleteSavedInstance. ]
		ifTrue: [ OPGHAuthor savedInstance: author. ].
	self commitChangesForProject: project withDiagram: diagram.
]

{ #category : #'querying-github' }
OpenPonkGit >> blobUrlFor: aFile [

	^ self subclassResponsibility
]

{ #category : #accessing }
OpenPonkGit >> commit [
	^ commit
]

{ #category : #accessing }
OpenPonkGit >> commit: anObject [
	commit := anObject
]

{ #category : #'querying-github' }
OpenPonkGit >> commitChangesFor: aFileCollection [

	self subclassResponsibility
]

{ #category : #'querying-github' }
OpenPonkGit >> commitChangesForProject: aProjectController withDiagram: aCanvasModel [
	| projectFile pngFile |
	aProjectController saveProject.
	projectFile := (aProjectController project storageFile ifNil: []) pathString.
	pngFile := projectFile copyReplaceAll: '.opp' with: '.png'.
	aCanvasModel exportCanvasToPng: pngFile asFileReference.
	self commitChangesFor: { OPGHFile withPath: projectFile. OPGHFile withPath: pngFile. }.
]

{ #category : #'commit-process' }
OpenPonkGit >> commitSet: aForm [
	commit repository: aForm textRepository text.
	commit branch: aForm textBranch text.
	aForm checkBoxSave state ifFalse: [ OPGHCommit deleteSavedInstance. ]
		ifTrue: [ OPGHCommit savedInstance: commit. ].
	commit message: aForm textMsg text.
	self setAuthor.
]

{ #category : #accessing }
OpenPonkGit >> credentials [
	^ credentials
]

{ #category : #accessing }
OpenPonkGit >> credentials: anObject [
	credentials := anObject
]

{ #category : #'commit-process' }
OpenPonkGit >> credentialsSet: aForm [
	credentials token: aForm textToken text.
	aForm checkBoxSave state ifFalse: [ OPGHCredentials deleteSavedInstance. ]
		ifTrue: [ OPGHCredentials savedInstance: credentials. ].
	self showCommitForm.
]

{ #category : #accessing }
OpenPonkGit >> diagram [
	^ diagram
]

{ #category : #accessing }
OpenPonkGit >> diagram: anObject [
	diagram := anObject
]

{ #category : #'fetch-process' }
OpenPonkGit >> directorySelected: aDirectoryPath [

	(self fetchProjectAndSaveItTo: aDirectoryPath)
		select: [ :each | each endsWith: '.opp' ]
		thenDo: [ :each | 
		(OPProjectController fromFile: each asFileReference) open ]
]

{ #category : #'fetch-process' }
OpenPonkGit >> fetchCredentialsFilled: aForm [
	credentials token: aForm textToken text.
	self showFetchRepositoryForm.
]

{ #category : #'fetch-process' }
OpenPonkGit >> fetchProjectAndSaveItTo: aDirectoryPath [

	| fileBlobs |
	fileBlobs := self getFileBlobsOf: self getLastCommitSha.
	^ fileBlobs collect: [ :blob | 
		  self getContentFor: blob.
		  blob saveTo: aDirectoryPath ]
]

{ #category : #'fetch-process' }
OpenPonkGit >> fetchRepositoryFilled: aForm [
	commit repository: aForm textRepository text.
	commit branch: aForm textBranch text.
	self showDirectoryDialog.
]

{ #category : #'commit-process' }
OpenPonkGit >> getAuthorEmail [

	| options |
	options := self getPossibleAuthorEmails.
	^ options first at: #email
]

{ #category : #'querying-github' }
OpenPonkGit >> getContentFor: aFile [

	| client response |
	client := ZnClient new.
	client url: (self blobUrlFor: aFile).
	self prepareGet: client.
	response := NeoJSONReader fromString: client get.
	aFile content: (response at: 'content').
	aFile encoding: (response at: 'encoding')
]

{ #category : #'querying-github' }
OpenPonkGit >> getFileBlobsOf: aLastCommitSha [

	^ self subclassResponsibility
]

{ #category : #'private-entity creation' }
OpenPonkGit >> getFileTreeStringFor: aFile [

	^ self subclassResponsibility
]

{ #category : #'querying-github' }
OpenPonkGit >> getLastCommitSha [

	| client response |
	client := ZnClient new.
	client url: self userRepositoryURL , '/branches/' , commit branch.
	self prepareGet: client.
	response := NeoJSONReader fromString: client get.
	^ (response at: 'commit') at: self shaKey
]

{ #category : #'commit-process' }
OpenPonkGit >> getPossibleAuthorEmails [

	| client |
	client := ZnClient new.
	client url: self apiURL , '/user/emails'.
	self prepareGet: client.
	^ NeoJSONReader fromString: client get
]

{ #category : #'querying-github' }
OpenPonkGit >> getTreeShaFrom: aCommitSha [

	^ self subclassResponsibility
]

{ #category : #initialization }
OpenPonkGit >> initialize [
	author := OPGHAuthor getInstance.
	credentials := OPGHCredentials getInstance.
	commit := OPGHCommit getInstance.
]

{ #category : #'as yet unclassified' }
OpenPonkGit >> prepareGet: client [

	self addTokenTo: client
]

{ #category : #'as yet unclassified' }
OpenPonkGit >> preparePost: client [

	self addTokenTo: client
]

{ #category : #accessing }
OpenPonkGit >> project [
	^ project
]

{ #category : #accessing }
OpenPonkGit >> project: anObject [
	project := anObject
]

{ #category : #'constants - url' }
OpenPonkGit >> reposURL [

	^ self subclassResponsibility
]

{ #category : #'commit-process' }
OpenPonkGit >> setAuthor [

	| client response |
	client := ZnClient new.
	client url: self apiURL , '/user'.
	self prepareGet: client.
	response := NeoJSONReader fromString: client get.
	author name: ((response at: 'name') ifNil: [ 
			 ^ self error: 'Cannot get your name from git' ]).
	author email: ((response at: 'email') ifNil: [ self getAuthorEmail ]).
	self commitChangesForProject: project withDiagram: diagram
]

{ #category : #'as yet unclassified' }
OpenPonkGit >> shaKey [

	^ 'sha'
]

{ #category : #'commit-process' }
OpenPonkGit >> showCommitCredentialsForm [

	| ui savedCredentials |
	ui := OpenPonkGitCredentialsUI new.
	ui callOnConfirm: [ self credentialsSet: ui ].
	savedCredentials := OPGHCredentials savedInstance.
	savedCredentials ifNotNil: [ 
		ui textToken text: savedCredentials token.
		ui checkBoxSave state: true ].
	ui open
]

{ #category : #'commit-process' }
OpenPonkGit >> showCommitForm [

	| ui savedCommit |
	ui := OpenPonkGitCommitUI new.
	ui model: self.
	savedCommit := OPGHCommit savedInstance.
	savedCommit ifNotNil: [ 
		ui textRepository text: savedCommit repository.
		ui textBranch text: savedCommit branch.
		ui checkBoxSave state: true ].
	ui open
]

{ #category : #'fetch-process' }
OpenPonkGit >> showDirectoryDialog [

	StFBOpenDirectoryDialog chooseThenDo: [ :directory | 
		self directorySelected: directory pathString ]
]

{ #category : #'fetch-process' }
OpenPonkGit >> showFetchCredentialsForm [

	| ui savedCredentials |
	ui := OpenPonkGitCredentialsUI new.
	ui callOnConfirm: [ self fetchCredentialsFilled: ui ].
	savedCredentials := OPGHCredentials savedInstance.
	savedCredentials ifNotNil: [ 
		ui textToken text: savedCredentials token.
		ui checkBoxSave state: true ].
	ui open
]

{ #category : #'fetch-process' }
OpenPonkGit >> showFetchRepositoryForm [

	| ui repository |
	ui := OpenPonkGitFetchUI new.
	ui model: self.
	repository := OPGHCommit savedInstance.
	repository ifNotNil: [ 
		ui textRepository text: repository repository.
		ui textBranch text: repository branch.
		ui checkBoxSave state: true ].
	ui open
]

{ #category : #'commit-process' }
OpenPonkGit >> startCommitProcess [
	self showCommitCredentialsForm.
]

{ #category : #'fetch-process' }
OpenPonkGit >> startFetchProcess [
	self showFetchCredentialsForm.
]

{ #category : #'constants - url' }
OpenPonkGit >> userRepositoryURL [
	^ self reposURL , '/' , commit repository.
]
