Class {
	#name : #OpenPonkGithub,
	#superclass : #Object,
	#instVars : [
		'author',
		'credentials',
		'commit',
		'project',
		'diagram'
	],
	#category : #'OpenPonk-Github'
}

{ #category : #initialization }
OpenPonkGithub class >> withProject: aProjectController withDiagram: aCanvasModel [
	| instance |
	instance := self new.
	instance project: aProjectController.
	instance diagram: aCanvasModel.
	^ instance.
]

{ #category : #'constants - url' }
OpenPonkGithub >> apiURL [
	^ 'https://api.github.com'
]

{ #category : #accessing }
OpenPonkGithub >> author [ 
	^ author.
]

{ #category : #accessing }
OpenPonkGithub >> author: aAuthor [
	author := aAuthor.
]

{ #category : #'commit-process' }
OpenPonkGithub >> authorSet: aForm [
	author name: aForm textName text.
	author email: aForm textEmail text.
	aForm checkBoxSave state ifFalse: [ OPGHAuthor deleteSavedInstance. ]
		ifTrue: [ OPGHAuthor savedInstance: author. ].
	self commitChangesForProject: project withDiagram: diagram.
]

{ #category : #accessing }
OpenPonkGithub >> commit [
	^ commit
]

{ #category : #accessing }
OpenPonkGithub >> commit: anObject [
	commit := anObject
]

{ #category : #'querying-github' }
OpenPonkGithub >> commitChangesFor: aFileCollection [
	| lastCommitSha treeSha commitSha |
	lastCommitSha := self getLastCommitSha.
	self postBlobsFor: aFileCollection.
	treeSha := self postTreesFor: aFileCollection withLastCommitSha: lastCommitSha.
	commitSha := self postCommitFor: aFileCollection withLastCommitSha: lastCommitSha withTreeSha: treeSha.
	self postBranchHeadFor: commitSha.
]

{ #category : #'querying-github' }
OpenPonkGithub >> commitChangesForProject: aProjectController withDiagram: aCanvasModel [
	| projectFile pngFile |
	aProjectController saveProject.
	projectFile := (aProjectController project storageFile ifNil: []) pathString.
	pngFile := projectFile copyReplaceAll: '.opp' with: '.png'.
	aCanvasModel exportCanvasToPng: pngFile asFileReference.
	self commitChangesFor: { OPGHFile withPath: projectFile. OPGHFile withPath: pngFile. }.
]

{ #category : #'commit-process' }
OpenPonkGithub >> commitCredentialsSet: aForm [
	credentials token: aForm textToken text.
	aForm checkBoxSave state ifFalse: [ OPGHCredentials deleteSavedInstance. ]
		ifTrue: [ OPGHCredentials savedInstance: credentials. ].
	self showCommitForm.
]

{ #category : #'commit-process' }
OpenPonkGithub >> commitSet: aForm [
	commit repository: aForm textRepository text.
	commit branch: aForm textBranch text.
	aForm checkBoxSave state ifFalse: [ OPGHCommit deleteSavedInstance. ]
		ifTrue: [ OPGHCommit savedInstance: commit. ].
	commit message: aForm textMsg text.
	self showAuthorForm.
]

{ #category : #accessing }
OpenPonkGithub >> credentials [
	^ credentials
]

{ #category : #accessing }
OpenPonkGithub >> credentials: anObject [
	credentials := anObject
]

{ #category : #'commit-process' }
OpenPonkGithub >> credentialsSet: aForm [
	credentials token: aForm textToken text.
	aForm checkBoxSave state ifFalse: [ OPGHCredentials deleteSavedInstance. ]
		ifTrue: [ OPGHCredentials savedInstance: credentials. ].
	self showCommitForm.
]

{ #category : #accessing }
OpenPonkGithub >> diagram [
	^ diagram
]

{ #category : #accessing }
OpenPonkGithub >> diagram: anObject [
	diagram := anObject
]

{ #category : #'fetch-process' }
OpenPonkGithub >> directorySelected: aDirectoryPath [
	self fetchProjectAndSaveItTo: aDirectoryPath.
]

{ #category : #'querying-github' }
OpenPonkGithub >> downloadContentFor: aFile [
	| client response |
	client := ZnClient new.
	client url: 	self userRepositoryURL , '/git/blobs/', aFile blobSha;
	headerAt: 'Accept' put: 'application/vnd.github.v3+json';
	headerAt: 'Authorization' put: 'token ' , credentials token.
	response := (NeoJSONReader fromString: (client get)).
	^ (response at: 'encoding') -> (response at: 'content').
]

{ #category : #'fetch-process' }
OpenPonkGithub >> fetchCredentialsFilled: aForm [
	credentials token: aForm textToken text.
	self showFetchRepositoryForm.
]

{ #category : #'fetch-process' }
OpenPonkGithub >> fetchFileContentFor: aFile [
	
]

{ #category : #'fetch-process' }
OpenPonkGithub >> fetchProjectAndSaveItTo: aDirectoryPath [
	| lastCommitSha treeSha fileBlobs | 
	lastCommitSha := self getLastCommitSha.
	treeSha := self getTreeShaFrom: lastCommitSha.
	fileBlobs := self getFileBlobsFrom: treeSha.
	fileBlobs do: [ :blob | 
		self getContentFor: blob.
		blob saveTo: aDirectoryPath. ].
	
]

{ #category : #'fetch-process' }
OpenPonkGithub >> fetchRepositoryFilled: aForm [
	commit repository: aForm textRepository text.
	commit branch: aForm textBranch text.
	self showDirectoryDialog.
]

{ #category : #'private-entity creation' }
OpenPonkGithub >> getBase64StringFor: aFile [
	^ '{
	"content":"' , (aFile contentBase64) contents ,'",
	"encoding": "base64"
}' .
]

{ #category : #'private-entity creation' }
OpenPonkGithub >> getCommitEntityWithCommitSha: commitSha withTreeSha: treeSha [
	 "POST /repos/:owner/:repo/git/blobs"
	^ ZnEntity with: '{
  "message": "', commit message ,'",
  "author": {
    "name": "', author name, '",
	 "email": "', author email ,'"
  },
  "parents": [
    "', commitSha ,'"
  ],
  "tree": "', treeSha ,'"
}'.
]

{ #category : #'querying-github' }
OpenPonkGithub >> getContentFor: aFile [
	 "POST /repos/:owner/:repo/git/blobs"
	| client response |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/blobs/' , aFile blobSha;
		headerAt: 'Accept' put: 'application/vnd.github.v3+json';
		headerAt: 'Authorization' put: 'token ' , credentials token.
	response := (NeoJSONReader fromString: client get). 
	aFile content: (response at: 'content').
	aFile encoding: (response at: 'encoding').
]

{ #category : #'querying-github' }
OpenPonkGithub >> getFileBlobsFrom: aTreeSha [
	| client response result |
	client := ZnClient new.
	client url: 	self userRepositoryURL , '/git/trees/', aTreeSha;
	headerAt: 'Accept' put: 'application/vnd.github.v3+json';
	headerAt: 'Authorization' put: 'token ' , credentials token.
	response := (NeoJSONReader fromString: (client get)) at: 'tree'.
	result := response collect: [ :blob | OPGHFile withPath: (blob at: 'path') withSha: (blob at: 'sha'). ].
	^ result select: [ :file | { 'opp' . 'png'. } includes: file extension. ].
]

{ #category : #'private-entity creation' }
OpenPonkGithub >> getFileTreeStringFor: aFile [
	^ '     {
       "path": "', (aFile name) ,'",
       "mode": "100644",
       "type": "blob",
       "sha": "', aFile blobSha , '"
     }'.
]

{ #category : #'querying-github' }
OpenPonkGithub >> getLastCommitSha [
	| client response |
	client := ZnClient new.
	client url: self userRepositoryURL , '/branches/' , commit branch.
	response := NeoJSONReader fromString: client get.
	^ (response at: 'commit') at: 'sha'.
]

{ #category : #'private-entity creation' }
OpenPonkGithub >> getTreeEntityFor: aFileCollection withLastCommitSha: aLastCommitSha [
	| fileStrings array |
	fileStrings :=  ''.
	array := aFileCollection asArray.
	1 to: (aFileCollection size - 1) do: [ :index |
		 fileStrings := fileStrings , (self getFileTreeStringFor: (array at: index)) , ',
		'. ].
	fileStrings := fileStrings , (self getFileTreeStringFor: (array at: aFileCollection size)).
	^ ZnEntity with: '{
   "base_tree": "' , aLastCommitSha , '",
   "tree": [' , fileStrings , '
   ]
 }' type: ZnMimeType applicationJson.
]

{ #category : #'querying-github' }
OpenPonkGithub >> getTreeShaFrom: aCommitSha [
	| client |
	client := ZnClient new.
	client url: 	self userRepositoryURL , '/git/commits/', aCommitSha;
	headerAt: 'Accept' put: 'application/vnd.github.v3+json';
	headerAt: 'Authorization' put: 'token ' , credentials token.
	^ (NeoJSONReader fromString: (client get)) at: 'tree' at: 'sha'.
]

{ #category : #initialization }
OpenPonkGithub >> initialize [
	author := OPGHAuthor getInstance.
	credentials := OPGHCredentials getInstance.
	commit := OPGHCommit getInstance.
]

{ #category : #'querying-github' }
OpenPonkGithub >> postBlobsFor: aFileCollection [
	 "POST /repos/:owner/:repo/git/blobs"
	| client |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/blobs';
		headerAt: 'Accept' put: 'application/vnd.github.v3+json';
		headerAt: 'Authorization' put: 'token ' , credentials token.
	aFileCollection do: [ :file |
		 client contents: (self getBase64StringFor: file).
		file blobSha: ((NeoJSONReader fromString: client post) at: 'sha'). ].
]

{ #category : #'querying-github' }
OpenPonkGithub >> postBranchHeadFor: aCommitSha [
	 "POST /repos/:owner/:repo/git/blobs"
	| client |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/refs/heads/' , commit branch;
		headerAt: 'Accept' put: 'application/vnd.github.v3+json';
		headerAt: 'Authorization' put: 'token ' , credentials token;
	entity: (ZnEntity with: '{
  "ref": "refs/heads/', commit branch ,'",
  "sha": "', aCommitSha ,'"
}' type: ZnMimeType applicationJson).
^ NeoJSONReader fromString: client post.
]

{ #category : #'querying-github' }
OpenPonkGithub >> postCommitFor: aFileCollection withLastCommitSha: aLastCommitSha withTreeSha: aTreeSha [
	 "POST /repos/:owner/:repo/git/blobs"
	| client |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/commits';
		headerAt: 'Accept' put: 'application/vnd.github.v3+json';
		headerAt: 'Authorization' put: 'token ' , credentials token.
	client entity: (self getCommitEntityWithCommitSha: aLastCommitSha withTreeSha: aTreeSha).
	^ ((NeoJSONReader fromString: client post) at: 'sha').
]

{ #category : #'querying-github' }
OpenPonkGithub >> postTreesFor: aFileCollection withLastCommitSha: aLastCommitSha [
	 "POST /repos/:owner/:repo/git/trees"
	| client |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/trees';
		headerAt: 'Accept' put: 'application/vnd.github.v3+json';
		headerAt: 'Authorization' put: 'token ' , credentials token.
	client entity: (self getTreeEntityFor: aFileCollection withLastCommitSha: aLastCommitSha ).
	^ ((NeoJSONReader fromString: client post) at: 'sha').
]

{ #category : #accessing }
OpenPonkGithub >> project [
	^ project
]

{ #category : #accessing }
OpenPonkGithub >> project: anObject [
	project := anObject
]

{ #category : #'constants - url' }
OpenPonkGithub >> reposURL [
	^ self apiURL , '/repos'
]

{ #category : #'commit-process' }
OpenPonkGithub >> showAuthorForm [
	| ui savedAuthor |
	ui := OpenPonkGithubAuthorUI new.
	ui model: self.
	savedAuthor := OPGHAuthor savedInstance.
	savedAuthor ifNotNil: [ ui textName text: savedAuthor name.
		ui textEmail text: savedAuthor email. 
		ui checkBoxSave state: true.].
	ui openWithSpec.
]

{ #category : #'commit-process' }
OpenPonkGithub >> showCommitCredentialsForm [
	| ui savedCredentials |
	ui := OpenPonkGithubCredentialsUI new.
	ui callOnConfirm: [ self credentialsSet: ui ].
	savedCredentials := OPGHCredentials savedInstance.
	savedCredentials ifNotNil: [ ui textToken text: savedCredentials token. 
		ui checkBoxSave state: true. ].
	ui openWithSpec.
]

{ #category : #'commit-process' }
OpenPonkGithub >> showCommitForm [
	| ui savedCommit |
	ui := OpenPonkGithubCommitUI new.
	ui model: self.
	savedCommit := OPGHCommit savedInstance.
	savedCommit ifNotNil: [ ui textRepository text: savedCommit repository.
		ui textBranch text: savedCommit branch. 
		ui checkBoxSave state: true. ].
	ui openWithSpec.
]

{ #category : #'fetch-process' }
OpenPonkGithub >> showDirectoryDialog [

	StFBFileDialogPresenter chooseThenDo: [ :directory | 
		self directorySelected: directory pathString ]
]

{ #category : #'fetch-process' }
OpenPonkGithub >> showFetchCredentialsForm [
	| ui savedCredentials |
	ui := OpenPonkGithubCredentialsUI new.
	ui callOnConfirm: [ self fetchCredentialsFilled: ui ].
	savedCredentials := OPGHCredentials savedInstance.
	savedCredentials ifNotNil: [ ui textToken text: savedCredentials token. 
		ui checkBoxSave state: true. ].
	ui openWithSpec.
]

{ #category : #'fetch-process' }
OpenPonkGithub >> showFetchRepositoryForm [
	| ui repository |
	ui := OpenPonkGithubFetchUI new.
	ui model: self.
	repository := OPGHCommit savedInstance.
	repository ifNotNil: [ ui textRepository text: repository repository.
		ui textBranch text: repository branch. 
		ui checkBoxSave state: true. ].
	ui openWithSpec.
]

{ #category : #'commit-process' }
OpenPonkGithub >> startCommitProcess [
	self showCommitCredentialsForm.
]

{ #category : #'fetch-process' }
OpenPonkGithub >> startFetchProcess [
	self showFetchCredentialsForm.
]

{ #category : #'constants - url' }
OpenPonkGithub >> userRepositoryURL [
	^ self reposURL , '/' , commit repository.
]
