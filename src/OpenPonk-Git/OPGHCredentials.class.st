"
I encapsulate Git authentication credentials, primarily the personal access token required for API operations. I provide a mechanism to persist this information globally across the session.
"
Class {
	#name : 'OPGHCredentials',
	#superclass : 'Object',
	#instVars : [
		'token'
	],
	#classInstVars : [
		'savedInstance'
	],
	#category : 'OpenPonk-Git',
	#package : 'OpenPonk-Git'
}

{ #category : 'actions' }
OPGHCredentials class >> deleteSavedInstance [

	savedInstance := nil
]

{ #category : 'accessing' }
OPGHCredentials class >> getInstance [
	^ savedInstance ifNil: [ ^ self new. ].
]

{ #category : 'accessing' }
OPGHCredentials class >> savedInstance [
	^ savedInstance.
]

{ #category : 'accessing' }
OPGHCredentials class >> savedInstance: aInstance [

	savedInstance := aInstance
]

{ #category : 'accessing' }
OPGHCredentials >> token [
	^ token.
]

{ #category : 'accessing' }
OPGHCredentials >> token: aString [
	token := aString.
]
