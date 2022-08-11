Class {
	#name : #OpenPonkGithub,
	#superclass : #OpenPonkGit,
	#category : #'OpenPonk-Git'
}

{ #category : #'as yet unclassified' }
OpenPonkGithub >> addAcceptTo: client [

	client headerAt: 'Accept' put: 'application/vnd.github.v3+json'
]

{ #category : #adding }
OpenPonkGithub >> addTokenTo: client [

	client headerAt: 'Authorization' put: 'token ' , credentials token
]

{ #category : #'as yet unclassified' }
OpenPonkGithub >> apiName [

	^ 'GitHub'
]

{ #category : #'constants - url' }
OpenPonkGithub >> apiURL [
	^ 'https://api.github.com'
]

{ #category : #'querying-github' }
OpenPonkGithub >> blobUrlFor: aFile [

	^ self userRepositoryURL , '/git/blobs/' , aFile blobSha
]

{ #category : #'querying-github' }
OpenPonkGithub >> commitChangesFor: aFileCollection [

	| lastCommitSha treeSha commitSha |
	lastCommitSha := self getLastCommitSha.
	self postBlobsFor: aFileCollection.
	treeSha := self
		           postTreesFor: aFileCollection
		           withLastCommitSha: lastCommitSha.
	commitSha := self
		             postCommitFor: aFileCollection
		             withLastCommitSha: lastCommitSha
		             withTreeSha: treeSha.
	self postBranchHeadFor: commitSha.
	self informCommited
]

{ #category : #'private-entity creation' }
OpenPonkGithub >> getBase64StringFor: aFile [

	^ '{
	"content":"' , aFile contentBase64 contents , '",
	"encoding": "base64"
}'
]

{ #category : #'private-entity creation' }
OpenPonkGithub >> getCommitEntityWithCommitSha: commitSha withTreeSha: treeSha [

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

{ #category : #'querying-github' }
OpenPonkGithub >> getFileBlobs [

	^ self getFileBlobsFrom: self getTreeSha
]

{ #category : #'querying-github' }
OpenPonkGithub >> getFileBlobsFrom: aTreeSha [

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

{ #category : #'private-entity creation' }
OpenPonkGithub >> getFileTreeStringFor: aFile [

	^ '     {
       "path": "' , aFile name , '",
       "mode": "100644",
       "type": "blob",
       "sha": "' , aFile blobSha , '"
     }'
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
OpenPonkGithub >> getTreeSha [

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

{ #category : #'querying-github' }
OpenPonkGithub >> postBlobsFor: aFileCollection [

	"POST /repos/:owner/:repo/git/blobs"

	| client response |
	client := ZnClient new.
	client url: self userRepositoryURL , '/git/blobs'.
	self preparePost: client.
	response := [ :job | 
	            job title: 'Uploading files to repository'.
	            NeoJSONReader fromString: client post ] asJob run.
	aFileCollection do: [ :file | 
		client contents: (self getBase64StringFor: file).
		file blobSha: (response at: self shaKey) ]
]

{ #category : #'querying-github' }
OpenPonkGithub >> postBranchHeadFor: aCommitSha [

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

{ #category : #'querying-github' }
OpenPonkGithub >> postCommitFor: aFileCollection withLastCommitSha: aLastCommitSha withTreeSha: aTreeSha [

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

{ #category : #'querying-github' }
OpenPonkGithub >> postTreesFor: aFileCollection withLastCommitSha: aLastCommitSha [

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

{ #category : #'as yet unclassified' }
OpenPonkGithub >> prepareGet: client [

	super prepareGet: client.
	self addAcceptTo: client
]

{ #category : #'as yet unclassified' }
OpenPonkGithub >> preparePost: client [

	super preparePost: client.
	self addAcceptTo: client
]

{ #category : #'constants - url' }
OpenPonkGithub >> reposURL [

	^ self apiURL , '/repos'
]
