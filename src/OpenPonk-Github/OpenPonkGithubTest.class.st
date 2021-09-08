Class {
	#name : #OpenPonkGithubTest,
	#superclass : #TestCase,
	#category : #'OpenPonk-Github'
}

{ #category : #constants }
OpenPonkGithubTest >> expectedCommitEntity [
	^ ZnEntity with: '{
  "message": "Commit message",
  "author": {
    "name": "AuthorName",
	 "email": "Author@email.com"
  },
  "parents": [
    "commitSha"
  ],
  "tree": "treeSha"
}'.
]

{ #category : #constants }
OpenPonkGithubTest >> expectedFileTreeString [
	^ '     {
       "path": "/test/path/1",
       "mode": "100644",
       "type": "blob",
       "sha": "blobSha1"
     }'.
]

{ #category : #constants }
OpenPonkGithubTest >> expectedTreeEntity [
	^ ZnEntity with: '{
   "base_tree": "commitSha",
   "tree": [     {
       "path": "/test/path/1",
       "mode": "100644",
       "type": "blob",
       "sha": "blobSha1"
     },
		     {
       "path": "/test/path/2",
       "mode": "100644",
       "type": "blob",
       "sha": "blobSha2"
     },
		     {
       "path": "/test/path/3",
       "mode": "100644",
       "type": "blob",
       "sha": "blobSha3"
     }
   ]
 }' type: ZnMimeType applicationJson.
]

{ #category : #constants }
OpenPonkGithubTest >> fileCollection [
	| fileCollection |
	fileCollection := OrderedCollection new.
	fileCollection add: ((OPGHFile withPath: '/test/path/1') blobSha: 'blobSha1' );
		add: ((OPGHFile withPath: '/test/path/2') blobSha: 'blobSha2' );
		add: ((OPGHFile withPath: '/test/path/3') blobSha: 'blobSha3' ).
	^ fileCollection.
]

{ #category : #constants }
OpenPonkGithubTest >> getTestInstance [
	| instance author |
	instance := OpenPonkGithub new.
	author := OPGHAuthor new.
	author name: 'AuthorName';
		email: 'Author@email.com'. 
	instance author: author;
	 	branch: 'testBranch';
	 	message: 'Commit message';
	 	repository: 'testRepository';
	 	token: 'authToken';
	 	username: 'authUsername'.
	^ instance.
]

{ #category : #tests }
OpenPonkGithubTest >> testAuthor [
	| client author |
	client := OpenPonkGithub new.
	author := OPGHAuthor new.
	author name: 'a'.
	author email: '&'.
	client author: author.
	self assert: client author  equals: author.
]

{ #category : #tests }
OpenPonkGithubTest >> testBranch [
	| client branch |
	client := OpenPonkGithub new.
	branch := 'test'.
	client branch: branch.
	self assert: client branch equals: branch.
]

{ #category : #tests }
OpenPonkGithubTest >> testGetCommitEntityWithCommitShaWithTreeSha [
	| instance |
	instance := self getTestInstance.
	self assert: 
		(instance getCommitEntityWithCommitSha: 'commitSha' withTreeSha: 'treeSha')
		equals: self expectedCommitEntity. 
]

{ #category : #tests }
OpenPonkGithubTest >> testGetFileTreeStringFor [
	| instance |
	instance := self getTestInstance.
	self assert: 
		(instance getFileTreeStringFor: ((OPGHFile withPath: '/test/path/1') blobSha: 'blobSha1'))
		equals: self expectedFileTreeString. 
]

{ #category : #tests }
OpenPonkGithubTest >> testGetTreeEntityForWithLastCommitSha [
	| instance fileCollection |
	instance := self getTestInstance.
	fileCollection := self fileCollection.	
	self assert: 
		(instance getTreeEntityFor: fileCollection withLastCommitSha: 'commitSha')
		equals: self expectedTreeEntity. 
]

{ #category : #tests }
OpenPonkGithubTest >> testMessage [ 
	| client message |
	client := OpenPonkGithub new.
	message := 'test'.
	client message: message.
	self assert: client message equals: message.
]

{ #category : #tests }
OpenPonkGithubTest >> testRepository [
	| client repository |
	client := OpenPonkGithub new.
	repository := 'test'.
	client repository: repository.
	self assert: client repository equals: repository.
]

{ #category : #tests }
OpenPonkGithubTest >> testToken [
	| client token |
	client := OpenPonkGithub new.
	token := 'token'.
	client token: token.
	self assert: client token equals: token.
]

{ #category : #tests }
OpenPonkGithubTest >> testUsername [
	| client username |
	client := OpenPonkGithub new.
	username := 'username'.
	client username: username.
	self assert: client username equals: username.
]
