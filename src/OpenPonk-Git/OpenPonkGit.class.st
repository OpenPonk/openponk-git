Class {
	#name : 'OpenPonkGit',
	#superclass : 'Object',
	#instVars : [
		'author',
		'credentials',
		'commit',
		'project',
		'diagram',
		'finishedAction',
		'lastCommitSha'
	],
	#category : 'OpenPonk-Git',
	#package : 'OpenPonk-Git'
}

{ #category : 'initialization' }
OpenPonkGit class >> withProject: aProjectController withDiagram: aCanvasModel [
	| instance |
	instance := self new.
	instance project: aProjectController.
	instance diagram: aCanvasModel.
	^ instance.
]

{ #category : 'adding' }
OpenPonkGit >> addTokenTo: client [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OpenPonkGit >> apiName [

	^ 'Git'
]

{ #category : 'constants - url' }
OpenPonkGit >> apiURL [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OpenPonkGit >> author [ 
	^ author.
]

{ #category : 'accessing' }
OpenPonkGit >> author: aAuthor [
	author := aAuthor.
]

{ #category : 'querying-github' }
OpenPonkGit >> blobUrlFor: aFile [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OpenPonkGit >> commit [
	^ commit
]

{ #category : 'accessing' }
OpenPonkGit >> commit: anObject [
	commit := anObject
]

{ #category : 'querying-github' }
OpenPonkGit >> commitChangesFor: aFileCollection [

	self subclassResponsibility
]

{ #category : 'querying-github' }
OpenPonkGit >> commitChangesForProject: aProjectController withDiagram: aCanvasModel [

	| projectFile pngFile |
	aProjectController saveProject.
	projectFile := aProjectController project storageFile ifNil: [ 
		               ^ self error: 'Saving project failed' ].
	pngFile := projectFile withExtension: 'png'.
	aCanvasModel exportCanvasToPng: pngFile.
	self commitChangesFor: { 
			(OPGHFile withPath: projectFile basename file: projectFile).
			(OPGHFile withPath: pngFile basename file: projectFile) }.
	finishedAction value: { 
			projectFile.
			pngFile }
]

{ #category : 'commit-process' }
OpenPonkGit >> commitSet: aForm [

	self repositoryFilled: aForm.
	commit message: aForm textMsg text.
	self findAuthorAndProceed
]

{ #category : 'accessing' }
OpenPonkGit >> credentials [
	^ credentials
]

{ #category : 'accessing' }
OpenPonkGit >> credentials: anOPGHCredentials [ 
	credentials := anOPGHCredentials
]

{ #category : 'accessing' }
OpenPonkGit >> diagram [
	^ diagram
]

{ #category : 'accessing' }
OpenPonkGit >> diagram: anObject [
	diagram := anObject
]

{ #category : 'accessing' }
OpenPonkGit >> directoryInRepo [

	^ ''
]

{ #category : 'fetch-process' }
OpenPonkGit >> directorySelected: aDirectoryPath [

	| projectControllers |
	projectControllers := (self fetchProjectAndSaveItTo: aDirectoryPath)
		                      select: [ :each | each endsWith: '.opp' ]
		                      thenCollect: [ :each | 
			                      (OPProjectController fromFile:
				                       each asFileReference) open
				                      projectController ].

	finishedAction value: projectControllers
]

{ #category : 'exceptions' }
OpenPonkGit >> errorFrom: aCollection missing: aString [

	| message |
	message := aCollection at: #message ifAbsent: [ 
		           self apiName, ' server did not return "' , aString
		           , '" property as part of the response' ].

	(message includesSubstring: 'Not Found') ifTrue: [ 
		message := message
		           ,
		           '. Git repository does not exist or your access token is invalid.' ].

	self error: message
]

{ #category : 'fetch-process' }
OpenPonkGit >> fetchProjectAndSaveItTo: aDirectoryPath [

	| fileBlobs |
	fileBlobs := self getFileBlobs.
	^ fileBlobs collect: [ :blob | 
		  self getContentFor: blob.
		  blob saveTo: aDirectoryPath ]
]

{ #category : 'fetch-process' }
OpenPonkGit >> fetchRepositoryFilled: aForm [

	self repositoryFilled: aForm.
	self showDirectoryDialog
]

{ #category : 'as yet unclassified' }
OpenPonkGit >> filterBlobs: blobDictionaryCollection [

	| result |
	result := blobDictionaryCollection collect: [ :each | 
		          OPGHFile
			          withPath: (each at: 'path')
			          withSha: (each at: self shaKey) ].

	^ result select: [ :file | { 'opp'. 'png' } includes: file extension ]
]

{ #category : 'commit-process' }
OpenPonkGit >> findAuthorAndProceed [

	| client response |
	client := ZnClient new.
	client url: self apiURL , '/user'.
	self prepareGet: client.
	response := [ :job | 
	            job title: 'Getting your name and email address'.
	            NeoJSONReader fromString: client get ] asJob run.
	author name: ((response at: 'name') ifNil: [ 
			 ^ self error: 'Cannot get your name from git' ]).
	author email: ((response at: 'email') ifNil: [ self getAuthorEmail ]).
	self commitChangesForProject: project withDiagram: diagram
]

{ #category : 'commit-process' }
OpenPonkGit >> getAuthorEmail [

	| options |
	options := self getPossibleAuthorEmails.
	^ options first at: #email
]

{ #category : 'querying-github' }
OpenPonkGit >> getContentFor: aFile [

	| client response |
	client := ZnClient new.
	client url: (self blobUrlFor: aFile).
	self prepareGet: client.
	response := [ :job | 
	            job title: 'Getting contents of ' , aFile pathInRepo.
	            NeoJSONReader fromString: client get ] asJob run.
	aFile content: (response at: 'content').
	aFile encoding: (response at: 'encoding').
	(aFile localFile basename endsWith: '.json') ifTrue: [ 
		^ aFile contentDecoded ].
	^ aFile binaryContent
]

{ #category : 'querying-github' }
OpenPonkGit >> getFileBlobs [

	^ self subclassResponsibility
]

{ #category : 'querying-github' }
OpenPonkGit >> getLastCommitSha [

	| client response |
	lastCommitSha ifNotNil: [ ^ lastCommitSha ].
	client := ZnClient new.
	client url: self userRepositoryURL , '/branches/' , commit branch.
	self prepareGet: client.
	response := [ :job | 
	            job title: 'Getting info about last repository commit'.
	            NeoJSONReader fromString: client get ] asJob run.
	^ lastCommitSha := (response
		                    at: 'commit'
		                    ifAbsent: [ 
		                    self errorFrom: response missing: #comming ]) 
		                   at: self shaKey
]

{ #category : 'commit-process' }
OpenPonkGit >> getPossibleAuthorEmails [

	| client |
	client := ZnClient new.
	client url: self apiURL , '/user/emails'.
	self prepareGet: client.
	^ [ :job | 
	  job title: 'Getting your email address'.
	  NeoJSONReader fromString: client get ] asJob run
]

{ #category : 'as yet unclassified' }
OpenPonkGit >> informCommited [

	self inform: 'Model uploaded to ' , self apiName
]

{ #category : 'initialization' }
OpenPonkGit >> initialize [

	super initialize.

	author := OPGHAuthor getInstance.
	credentials := OPGHCredentials getInstance.
	commit := OPGHCommit getInstance.

	finishedAction := [ :items | items ]
]

{ #category : 'querying-github' }
OpenPonkGit >> prepareGet: client [

	self addTokenTo: client
]

{ #category : 'querying-github' }
OpenPonkGit >> preparePost: client [

	self addTokenTo: client
]

{ #category : 'accessing' }
OpenPonkGit >> project [
	^ project
]

{ #category : 'accessing' }
OpenPonkGit >> project: anObject [
	project := anObject
]

{ #category : 'constants - url' }
OpenPonkGit >> reposURL [

	^ self subclassResponsibility
]

{ #category : 'fetch-process' }
OpenPonkGit >> repositoryFilled: aForm [

	credentials token: aForm textToken text.
	commit repository: aForm textRepository text.
	commit branch: aForm textBranch text.
	aForm checkBoxSave state
		ifFalse: [ 
			OPGHCredentials deleteSavedInstance.
			OPGHCommit deleteSavedInstance ]
		ifTrue: [ 
			OPGHCommit savedInstance: commit.
			OPGHCredentials savedInstance: credentials ]
]

{ #category : 'querying-github' }
OpenPonkGit >> shaKey [

	^ 'sha'
]

{ #category : 'commit-process' }
OpenPonkGit >> showCommitForm [

	| ui savedCommit savedCredentials |
	ui := OpenPonkGitCommitUI new.
	ui model: self.
	ui onConfirmDo: [ self commitSet: ui ].
	savedCredentials := OPGHCredentials savedInstance.
	savedCredentials ifNotNil: [ 
		ui textToken text: savedCredentials token.
		ui checkBoxSave state: true ].
	savedCommit := OPGHCommit savedInstance.
	savedCommit ifNotNil: [ 
		ui textRepository text: savedCommit repository.
		ui textBranch text: savedCommit branch.
		ui checkBoxSave state: true ].
	ui open
]

{ #category : 'fetch-process' }
OpenPonkGit >> showDirectoryDialog [

	StFBOpenDirectoryDialog chooseThenDo: [ :directory | 
		self directorySelected: directory pathString ]
]

{ #category : 'fetch-process' }
OpenPonkGit >> showFetchForm [

	| ui repository savedCredentials |
	ui := OpenPonkGitFetchUI new.
	ui model: self.
	ui onConfirmDo: [ self fetchRepositoryFilled: ui ].
	savedCredentials := OPGHCredentials savedInstance.
	savedCredentials ifNotNil: [ 
		ui textToken text: savedCredentials token.
		ui checkBoxSave state: true ].
	repository := OPGHCommit savedInstance.
	repository ifNotNil: [ 
		ui textRepository text: repository repository.
		ui textBranch text: repository branch.
		ui checkBoxSave state: true ].
	ui open
]

{ #category : 'commit-process' }
OpenPonkGit >> startCommitProcess [

	self showCommitForm
]

{ #category : 'fetch-process' }
OpenPonkGit >> startFetchProcess [

	self showFetchForm
]

{ #category : 'constants - url' }
OpenPonkGit >> userRepositoryURL [
	^ self reposURL , '/' , commit repository.
]

{ #category : 'accessing' }
OpenPonkGit >> whenFinishedDo: aBlock [

	finishedAction := aBlock
]
