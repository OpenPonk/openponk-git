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

{ #category : #'as yet unclassified' }
OpenPonkGitlab >> apiName [

	^ 'GitLab.com'
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

	| client response |
	client := ZnClient new.
	client url: self userRepositoryURL , '/commits'.
	client entity: (self
			 getCommitEntityFor: aFileCollection
			 withCommitSha: self getLastCommitSha).
	self preparePost: client.
	response := [ :job | 
	            job title: 'Uploading commit to repository'.
	            NeoJSONReader fromString: client post ] asJob run.
	self informCommited.
	^ response at: self shaKey
]

{ #category : #'querying-github' }
OpenPonkGitlab >> getActionsToPostFiles: aFileCollection withCommitSha: aCommitSha [

	| paths |
	paths := [ self getFileBlobs collect: #pathInRepo as: Set ]
		         on: OPGHModelDoesNotExist
		         do: [ Set new ].
	^ aFileCollection collect: [ :eachFile | 
		  { 
			  ('action' -> ((paths includes: eachFile pathInRepo)
				    ifTrue: [ 'update' ]
				    ifFalse: [ 'create' ])).
			  ('file_path' -> eachFile pathInRepo).
			  ('encoding' -> 'base64').
			  ('content' -> eachFile contentBase64 contents) } asDictionary ]
]

{ #category : #'commit-process' }
OpenPonkGitlab >> getAuthorEmail [

	| options |
	options := self getPossibleAuthorEmails.
	^ (options detect: [ :any | 
		   (any at: #primary) and: [ any at: #verified ] ]) at: #email
]

{ #category : #'querying-github' }
OpenPonkGitlab >> getCommitEntityFor: aFileCollection withCommitSha: lastCommitSha [

	| actions |
	actions := self
		           getActionsToPostFiles: aFileCollection
		           withCommitSha: lastCommitSha.

	^ ZnEntity with: (OPJsonWriter toStringPretty: { 
				   ('branch' -> commit branch).
				   ('commit_message' -> commit message).
				   ('actions' -> actions) } asDictionary)
]

{ #category : #'querying-github' }
OpenPonkGitlab >> getFileBlobs [

	^ self filterBlobs:
		  (self getRepoItems select: [ :each | (each at: #type) = 'blob' ])
]

{ #category : #'querying-github' }
OpenPonkGitlab >> getRepoItems [

	| client response |
	client := ZnClient new.

	client url: self userRepositoryURL , '/tree'.
	client queryAt: #ref put: commit branch.
	client queryAt: #path put: self directoryInRepo.
	self prepareGet: client.
	response := [ :job | 
	            job title: 'Getting list of files in repository'.
	            NeoJSONReader fromString: client get ] asJob run.
	response ifEmpty: [ 
		^ OPGHModelDoesNotExist signalModel: self directoryInRepo ].
	client response statusLine code >= 300 ifTrue: [ 
		^ self error: (String streamContents: [ :s | 
				   s << client response statusLine code asString << ' on GitLab'.
				   response
					   at: #message
					   ifPresent: [ :message | s << ': ' << message asString ] ]) ].
	^ response
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

{ #category : #hooks }
OpenPonkGitlab >> shaKey [

	^ 'id'
]

{ #category : #'constants - url' }
OpenPonkGitlab >> userRepositoryURL [

	^ self reposURL , '/' , commit repository urlEncoded , '/repository'
]
