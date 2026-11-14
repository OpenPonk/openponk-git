"
I implement the OpenPonk Git integration specifically for the GitHub REST API. I manage the low-level API calls required to create blobs, trees, commits, and update branch references.
"
Class {
	#name : 'OPGitHub',
	#superclass : 'OPGit',
	#category : 'OpenPonk-Git-Model',
	#package : 'OpenPonk-Git',
	#tag : 'Model'
}

{ #category : 'adding' }
OPGitHub >> addAcceptTo: client [

	client headerAt: 'Accept' put: 'application/vnd.github.v3+json'
]

{ #category : 'adding' }
OPGitHub >> addTokenTo: client [

	client headerAt: 'Authorization' put: 'token ' , credentials token
]

{ #category : 'constants' }
OPGitHub >> apiName [

	^ 'GitHub'
]

{ #category : 'constants - url' }
OPGitHub >> apiURL [
	^ 'https://api.github.com'
]

{ #category : 'querying-github' }
OPGitHub >> blobUrlFor: aFile [

	^ self userRepositoryURL , '/git/blobs/' , aFile blobSha
]

{ #category : 'querying-github' }
OPGitHub >> commitChangesFor: aFileCollection [

	| treeSha commitSha |
	self postBlobsFor: aFileCollection.
	treeSha := self
		           postTreesFor: aFileCollection
		           withLastCommitSha: self getLastCommitSha.
	commitSha := self
		             postCommitFor: aFileCollection
		             withLastCommitSha: self getLastCommitSha
		             withTreeSha: treeSha.
	self postBranchHeadFor: commitSha.
	self informCommited
]

{ #category : 'private-entity creation' }
OPGitHub >> getBase64StringFor: aFile [

	^ '{
	"content":"' , aFile contentBase64 contents , '",
	"encoding": "base64"
}'
]

{ #category : 'private-entity creation' }
OPGitHub >> getCommitEntityWithCommitSha: commitSha withTreeSha: treeSha [

	"POST /repos/:owner/:repo/git/blobs"

	^ ZnEntity with: '{
  "message": "' , commit message , '",
  "author": {
    "name": "' , author name , '",
	 "email": "' , author email , '"
  },
  "parents": [
    "' , commitSha , '"
  ],
  "tree": "' , treeSha , '"
}'
]

{ #category : 'querying-github' }
OPGitHub >> getFileBlobs [

	^ self getFileBlobsFrom: self getTreeSha
]

{ #category : 'querying-github' }
OPGitHub >> getFileBlobsFrom: aTreeSha [

	| client response tree |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/trees/' , aTreeSha.
	self prepareGet: client.
	response := [ :job | 
	            job title: 'Getting list of files in repository'.
	            NeoJSONReader fromString: client get ] asJob run.
	tree := response at: #tree.
	^ self filterBlobs: tree
]

{ #category : 'private-entity creation' }
OPGitHub >> getFileTreeStringFor: aFile [

	^ '     {
        "path": "' , aFile pathInRepo , '",
        "mode": "100644",
        "type": "blob",
        "sha": "' , aFile blobSha , '"
      }'
]

{ #category : 'private-entity creation' }
OPGitHub >> getTreeEntityFor: aFileCollection withLastCommitSha: aLastCommitSha [
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

{ #category : 'querying-github' }
OPGitHub >> getTreeSha [

	| client response |
	client := ZnClient new.
	client url:
		self userRepositoryURL , '/git/commits/' , self getLastCommitSha.
	self prepareGet: client.
	response := [ :job | 
	            job title:
		            'Getting information about last commit in the repository'.
	            NeoJSONReader fromString: client get ] asJob run.
	^ response at: 'tree' at: 'sha'
]

{ #category : 'querying-github' }
OPGitHub >> postBlobsFor: aFileCollection [

	"POST /repos/:owner/:repo/git/blobs"

	aFileCollection do: [ :file |
		| client response |
		client := ZnClient new.
		client url: self userRepositoryURL , '/git/blobs'.
		client entity: (ZnEntity
			with: (self getBase64StringFor: file)
			type: ZnMimeType applicationJson).
		self preparePost: client.
		response := [ :job |
			job title: 'Uploading files to repository'.
			NeoJSONReader fromString: client post ] asJob run.
		file blobSha: (response at: self shaKey) ]
]

{ #category : 'querying-github' }
OPGitHub >> postBranchHeadFor: aCommitSha [

	"POST /repos/:owner/:repo/git/blobs"

	| client |
	client := ZnClient new.
	client url:
		self userRepositoryURL , '/git/refs/heads/' , commit branch.
	client entity: (ZnEntity
			 with: '{
  "ref": "refs/heads/' , commit branch , '",
  "sha": "' , aCommitSha , '"
}'
			 type: ZnMimeType applicationJson).

	self preparePost: client.
	^ [ :job | 
	  job title: 'Uploading branch info update to repository'.
	  NeoJSONReader fromString: client post ] asJob run
]

{ #category : 'querying-github' }
OPGitHub >> postCommitFor: aFileCollection withLastCommitSha: aLastCommitSha withTreeSha: aTreeSha [

	"POST /repos/:owner/:repo/git/blobs"

	| client response |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/commits'.
	client entity: (self
			 getCommitEntityWithCommitSha: aLastCommitSha
			 withTreeSha: aTreeSha).
	self preparePost: client.
	response := [ :job | 
	            job title: 'Uploading commit to repository'.
	            NeoJSONReader fromString: client post ] asJob run.
	^ response at: self shaKey
]

{ #category : 'querying-github' }
OPGitHub >> postTreesFor: aFileCollection withLastCommitSha: aLastCommitSha [

	"POST /repos/:owner/:repo/git/trees"

	| client response |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/trees'.
	client entity: (self
			 getTreeEntityFor: aFileCollection
			 withLastCommitSha: aLastCommitSha).
	self preparePost: client.
	response := [ :job | 
	            job title: 'Uploading updated file list to repository'.
	            NeoJSONReader fromString: client post ] asJob run.
	^ response at: self shaKey
]

{ #category : 'querying-github' }
OPGitHub >> prepareGet: client [

	super prepareGet: client.
	self addAcceptTo: client
]

{ #category : 'querying-github' }
OPGitHub >> preparePost: client [

	super preparePost: client.
	self addAcceptTo: client
]

{ #category : 'constants - url' }
OPGitHub >> reposURL [

	^ self apiURL , '/repos'
]
