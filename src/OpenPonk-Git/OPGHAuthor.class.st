"
I represent the author of a Git commit, containing a name and an email address. I provide a mechanism to persist this information globally across the session.
"
Class {
	#name : 'OPGHAuthor',
	#superclass : 'Object',
	#instVars : [
		'name',
		'email'
	],
	#classInstVars : [
		'savedInstance'
	],
	#category : 'OpenPonk-Git-Model',
	#package : 'OpenPonk-Git',
	#tag : 'Model'
}

{ #category : 'actions' }
OPGHAuthor class >> deleteSavedInstance [
	savedInstance := nil.
]

{ #category : 'accessing' }
OPGHAuthor class >> getInstance [
	^ savedInstance ifNil: [ ^ self new. ].
]

{ #category : 'accessing' }
OPGHAuthor class >> savedInstance [
	^ savedInstance.
]

{ #category : 'accessing' }
OPGHAuthor class >> savedInstance: aInstance [
	 savedInstance := aInstance.
]

{ #category : 'access' }
OPGHAuthor >> email [
	^ email.
]

{ #category : 'access' }
OPGHAuthor >> email: aString [
	email := aString.
]

{ #category : 'access' }
OPGHAuthor >> name [
	^ name.
]

{ #category : 'access' }
OPGHAuthor >> name: aString [
	name := aString.
]

{ #category : 'access' }
OPGHAuthor >> valid [
	^ self validName and: [ self validEmail ].
]

{ #category : 'access' }
OPGHAuthor >> validEmail [
	^ email isNotNil and: [ email includes: $@ ]
]

{ #category : 'access' }
OPGHAuthor >> validName [
	^ name isNotNil and: [ name isNotEmpty ]
]
