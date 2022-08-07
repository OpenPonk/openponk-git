Class {
	#name : #OpenPonkGitlab,
	#superclass : #OpenPonkGit,
	#category : #'OpenPonk-Git'
}

{ #category : #adding }
OpenPonkGitlab >> addContentTypeTo: client [

	client contentType: ZnMimeType applicationJson
]

{ #category : #'querying-github' }
OpenPonkGitlab >> addTokenTo: client [

	client headerAt: 'PRIVATE-TOKEN' put: credentials token
]

{ #category : #'constants - url' }
OpenPonkGitlab >> apiURL [
	^ 'https://gitlab.com/api/v4'
]

{ #category : #'querying-github' }
OpenPonkGitlab >> blobUrlFor: aFile [

	^ self userRepositoryURL , '/blobs/' , aFile blobSha
]

{ #category : #'querying-github' }
OpenPonkGitlab >> commitChangesFor: aFileCollection [

	| lastCommitSha client |
	lastCommitSha := self getLastCommitSha.
	client := ZnClient new.
	client url: self userRepositoryURL , '/commits'.
	client entity:
		(self
			 getCommitEntityFor: aFileCollection
			 withCommitSha: lastCommitSha).
	self preparePost: client.
	^ (NeoJSONReader fromString: client post) at: self shaKey
]

{ #category : #'querying-github' }
OpenPonkGitlab >> getActionsToPostFiles: aFileCollection withCommitSha: aCommitSha [

	| paths |
	paths := (self getFileBlobsOf: aCommitSha) collect: #path as: Set.
	^ aFileCollection collect: [ :eachFile | 
		  { 
			  ('action' -> ((paths includes: eachFile path)
				    ifTrue: [ 'update' ]
				    ifFalse: [ 'create' ])).
			  ('file_path' -> eachFile path).
			  ('encoding' -> 'base64').
			  ('content' -> eachFile contentBase64 contents) } asDictionary ]
]

{ #category : #'querying-github' }
OpenPonkGitlab >> getCommitEntityFor: aFileCollection withCommitSha: lastCommitSha [

	| actions |
	actions := self
		           getActionsToPostFiles: aFileCollection
		           withCommitSha: lastCommitSha.

	^ ZnEntity with: (NeoJSONWriter toStringPretty: { 
				   ('branch' -> commit branch).
				   ('commit_message' -> commit message).
				   ('actions' -> actions) } asDictionary)
]

{ #category : #'querying-github' }
OpenPonkGitlab >> getFileBlobsOf: aCommitSha [

	| client files |
	client := ZnClient new.
	client url: self userRepositoryURL , '/tree'.
	self prepareGet: client.
	files := (NeoJSONReader fromString: client get)
		         select: [ :each | (each at: #type) = 'blob' ]
		         thenCollect: [ :each | 
			         OPGHFile
				         withPath: (each at: 'path')
				         withSha: (each at: self shaKey) ].

	^ files select: [ :file | { 'opp'. 'png' } includes: file extension ]
]

{ #category : #'querying-github' }
OpenPonkGitlab >> preparePost: client [

	super preparePost: client.
	self addContentTypeTo: client
]

{ #category : #'constants - url' }
OpenPonkGitlab >> reposURL [

	^ self apiURL , '/projects'
]

{ #category : #'as yet unclassified' }
OpenPonkGitlab >> shaKey [

	^ 'id'
]

{ #category : #'constants - url' }
OpenPonkGitlab >> userRepositoryURL [

	^ self reposURL , '/' , commit repository urlEncoded , '/repository'
]
