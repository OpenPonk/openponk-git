Class {
	#name : #OpenPonkGithub,
	#superclass : #OpenPonkGit,
	#category : #'OpenPonk-Github'
}

{ #category : #'as yet unclassified' }
OpenPonkGithub >> addAcceptTo: client [

	client headerAt: 'Accept' put: 'application/vnd.github.v3+json'
]

{ #category : #adding }
OpenPonkGithub >> addTokenTo: client [

	client headerAt: 'Authorization' put: 'token ' , credentials token
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
	treeSha := self postTreesFor: aFileCollection withLastCommitSha: lastCommitSha.
	commitSha := self postCommitFor: aFileCollection withLastCommitSha: lastCommitSha withTreeSha: treeSha.
	self postBranchHeadFor: commitSha.
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

{ #category : #'querying-github' }
OpenPonkGithub >> getFileBlobsOf: aLastCommitSha [

	^ self getFileBlobsFrom: (self getTreeShaFrom: aLastCommitSha)
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
OpenPonkGithub >> getTreeShaFrom: aCommitSha [
	| client |
	client := ZnClient new.
	client url: 	self userRepositoryURL , '/git/commits/', aCommitSha;
	headerAt: 'Accept' put: 'application/vnd.github.v3+json';
	headerAt: 'Authorization' put: 'token ' , credentials token.
	^ (NeoJSONReader fromString: (client get)) at: 'tree' at: 'sha'.
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
