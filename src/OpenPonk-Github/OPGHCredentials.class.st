Class {
	#name : #OPGHCredentials,
	#superclass : #Object,
	#instVars : [
		'token'
	],
	#classInstVars : [
		'savedInstance'
	],
	#category : #'OpenPonk-Github'
}

{ #category : #accessing }
OPGHCredentials class >> deleteSavedInstance [
	savedInstance := nil.
]

{ #category : #accessing }
OPGHCredentials class >> getInstance [
	^ savedInstance ifNil: [ ^ self new. ].
]

{ #category : #accessing }
OPGHCredentials class >> savedInstance [
	^ savedInstance.
]

{ #category : #accessing }
OPGHCredentials class >> savedInstance: aInstance [
	 savedInstance := aInstance.
]

{ #category : #accessing }
OPGHCredentials >> token [
	^ token.
]

{ #category : #accessing }
OPGHCredentials >> token: aString [
	token := aString.
]
