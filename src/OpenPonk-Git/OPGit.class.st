"
I am the abstract base class orchestrating Git integration within OpenPonk. I handle the high-level workflow for fetching projects from and committing changes to remote Git repositories via their respective APIs.
"
Class {
	#name : 'OPGit',
	#superclass : 'Object',
	#instVars : [
		'author',
		'credentials',
		'commit',
		'project',
		'diagram',
		'finishedAction',
		'lastCommitSha',
		'spApplication'
	],
	#category : 'OpenPonk-Git-Model',
	#package : 'OpenPonk-Git',
	#tag : 'Model'
}

{ #category : 'initialization' }
OPGit class >> withProject: aProjectController withDiagram: aCanvasModel [
	| instance |
	instance := self new.
	instance project: aProjectController.
	instance diagram: aCanvasModel.
	^ instance.
]

{ #category : 'instance creation' }
OPGit class >> withSpApplication: aSpApplication [

	^ self new
		  spApplication: aSpApplication;
		  yourself
]

{ #category : 'adding' }
OPGit >> addTokenTo: client [

	self subclassResponsibility
]

{ #category : 'constants' }
OPGit >> apiName [

	^ 'Git'
]

{ #category : 'constants - url' }
OPGit >> apiURL [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPGit >> author [ 
	^ author.
]

{ #category : 'accessing' }
OPGit >> author: aAuthor [
	author := aAuthor.
]

{ #category : 'querying-github' }
OPGit >> blobUrlFor: aFile [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPGit >> commit [
	^ commit
]

{ #category : 'accessing' }
OPGit >> commit: anObject [
	commit := anObject
]

{ #category : 'querying-github' }
OPGit >> commitChangesFor: aFileCollection [

	self subclassResponsibility
]

{ #category : 'querying-github' }
OPGit >> commitChangesForProject: aProjectController withDiagram: aCanvasModel [

	| projectFile pngFile |
	aProjectController saveProject.
	projectFile := aProjectController project storageFile ifNil: [
		^ self error: 'Saving project failed' ].
	pngFile := projectFile withExtension: 'png'.
	aCanvasModel exportAsPng: pngFile.
	self commitChangesFor: {
		OPGHFile withPath: projectFile basename file: projectFile.
		OPGHFile withPath: pngFile basename file: pngFile }.
	finishedAction value: {
		projectFile.
		pngFile }
]

{ #category : 'commit-process' }
OPGit >> commitSet: aForm [

	self repositoryFilled: aForm.
	commit message: aForm textMsg text.
	self findAuthorAndProceed
]

{ #category : 'accessing' }
OPGit >> credentials [
	^ credentials
]

{ #category : 'accessing' }
OPGit >> credentials: anOPGHCredentials [ 
	credentials := anOPGHCredentials
]

{ #category : 'accessing' }
OPGit >> diagram [
	^ diagram
]

{ #category : 'accessing' }
OPGit >> diagram: anObject [
	diagram := anObject
]

{ #category : 'accessing' }
OPGit >> directoryInRepo [

	^ ''
]

{ #category : 'fetch-process' }
OPGit >> directorySelected: aDirectoryPath [

	| projectControllers |
	projectControllers := (self fetchProjectAndSaveItTo: aDirectoryPath)
		                      select: [ :each | each asFileReference extension = 'opp' ]
		                      thenCollect: [ :each |
			                      (OPProjectController fromFile:
				                       each asFileReference) open
				                      projectController ].

	finishedAction value: projectControllers
]

{ #category : 'exceptions' }
OPGit >> errorFrom: aCollection missing: aString [

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
OPGit >> fetchProjectAndSaveItTo: aDirectoryPath [

	| fileBlobs |
	fileBlobs := self getFileBlobs.
	^ fileBlobs collect: [ :blob | 
		  self getContentFor: blob.
		  blob saveTo: aDirectoryPath ]
]

{ #category : 'fetch-process' }
OPGit >> fetchRepositoryFilled: aForm [

	self repositoryFilled: aForm.
	self showDirectoryDialog
]

{ #category : 'utils' }
OPGit >> filterBlobs: blobDictionaryCollection [

	| result |
	result := blobDictionaryCollection collect: [ :each | 
		          OPGHFile
			          withPath: (each at: 'path')
			          withSha: (each at: self shaKey) ].

	^ result select: [ :file | { 'opp'. 'png' } includes: file extension ]
]

{ #category : 'commit-process' }
OPGit >> findAuthorAndProceed [

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
OPGit >> getAuthorEmail [

	| options |
	options := self getPossibleAuthorEmails.
	^ options first at: #email
]

{ #category : 'querying-github' }
OPGit >> getContentFor: aFile [

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
OPGit >> getFileBlobs [

	^ self subclassResponsibility
]

{ #category : 'querying-github' }
OPGit >> getLastCommitSha [

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
OPGit >> getPossibleAuthorEmails [

	| client |
	client := ZnClient new.
	client url: self apiURL , '/user/emails'.
	self prepareGet: client.
	^ [ :job | 
	  job title: 'Getting your email address'.
	  NeoJSONReader fromString: client get ] asJob run
]

{ #category : 'exceptions' }
OPGit >> informCommited [

	self inform: 'Model uploaded to ' , self apiName
]

{ #category : 'initialization' }
OPGit >> initialize [

	super initialize.

	author := OPGHAuthor getInstance.
	credentials := OPGHCredentials getInstance.
	commit := OPGHCommit getInstance.

	finishedAction := [ :items | items ]
]

{ #category : 'querying-github' }
OPGit >> prepareGet: client [

	self addTokenTo: client
]

{ #category : 'querying-github' }
OPGit >> preparePost: client [

	self addTokenTo: client
]

{ #category : 'accessing' }
OPGit >> project [
	^ project
]

{ #category : 'accessing' }
OPGit >> project: anObject [
	project := anObject
]

{ #category : 'constants - url' }
OPGit >> reposURL [

	^ self subclassResponsibility
]

{ #category : 'fetch-process' }
OPGit >> repositoryFilled: aForm [

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
OPGit >> shaKey [

	^ 'sha'
]

{ #category : 'commit-process' }
OPGit >> showCommitForm [

	| ui savedCommit savedCredentials |
	ui := OPGitCommitUI newApplication: self spApplication.
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
OPGit >> showDirectoryDialog [

	StOpenDirectoryPresenter chooseThenDo: [ :directory | 
		self directorySelected: directory pathString ]
]

{ #category : 'fetch-process' }
OPGit >> showFetchForm [

	| ui repository savedCredentials |
	ui := OPGitFetchUI newApplication: self spApplication.
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

{ #category : 'accessing' }
OPGit >> spApplication [

	^ spApplication ifNil: [ diagram application ]
]

{ #category : 'accessing' }
OPGit >> spApplication: aSpApplication [

	spApplication := aSpApplication
]

{ #category : 'commit-process' }
OPGit >> startCommitProcess [

	self showCommitForm
]

{ #category : 'fetch-process' }
OPGit >> startFetchProcess [

	self showFetchForm
]

{ #category : 'constants - url' }
OPGit >> userRepositoryURL [
	^ self reposURL , '/' , commit repository.
]

{ #category : 'accessing' }
OPGit >> whenFinishedDo: aBlock [

	finishedAction := aBlock
]
