"
I represent the target and metadata of a Git commit operation, including the target repository URL, branch name, and commit message. I provide a mechanism to persist this information globally across the session.
"
Class {
	#name : 'OPGHCommit',
	#superclass : 'Object',
	#instVars : [
		'repository',
		'branch',
		'message'
	],
	#classInstVars : [
		'savedInstance'
	],
	#category : 'OpenPonk-Git',
	#package : 'OpenPonk-Git'
}

{ #category : 'actions' }
OPGHCommit class >> deleteSavedInstance [
	savedInstance := nil.
]

{ #category : 'accessing' }
OPGHCommit class >> getInstance [
	^ savedInstance ifNil: [ ^ self new. ].
]

{ #category : 'accessing' }
OPGHCommit class >> savedInstance [
	^ savedInstance.
]

{ #category : 'accessing' }
OPGHCommit class >> savedInstance: aInstance [
	 savedInstance := aInstance.
]

{ #category : 'accessing' }
OPGHCommit >> branch [

	^ branch ifNil: [ 'master' ]
]

{ #category : 'accessing' }
OPGHCommit >> branch: anObject [
	branch := anObject
]

{ #category : 'accessing' }
OPGHCommit >> message [
	^ message
]

{ #category : 'accessing' }
OPGHCommit >> message: anObject [
	message := anObject
]

{ #category : 'accessing' }
OPGHCommit >> repository [
	^ repository
]

{ #category : 'accessing' }
OPGHCommit >> repository: anObject [
	repository := anObject
]
