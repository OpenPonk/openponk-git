Class {
	#name : #OPGHCommit,
	#superclass : #Object,
	#instVars : [
		'repository',
		'branch',
		'message'
	],
	#classInstVars : [
		'savedInstance'
	],
	#category : #'OpenPonk-Github'
}

{ #category : #accessing }
OPGHCommit class >> deleteSavedInstance [
	savedInstance := nil.
]

{ #category : #accessing }
OPGHCommit class >> getInstance [
	^ savedInstance ifNil: [ ^ self new. ].
]

{ #category : #accessing }
OPGHCommit class >> savedInstance [
	^ savedInstance.
]

{ #category : #accessing }
OPGHCommit class >> savedInstance: aInstance [
	 savedInstance := aInstance.
]

{ #category : #accessing }
OPGHCommit >> branch [
	^ branch
]

{ #category : #accessing }
OPGHCommit >> branch: anObject [
	branch := anObject
]

{ #category : #accessing }
OPGHCommit >> message [
	^ message
]

{ #category : #accessing }
OPGHCommit >> message: anObject [
	message := anObject
]

{ #category : #accessing }
OPGHCommit >> repository [
	^ repository
]

{ #category : #accessing }
OPGHCommit >> repository: anObject [
	repository := anObject
]
