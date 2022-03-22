Class {
	#name : #OPGHAuthor,
	#superclass : #Object,
	#instVars : [
		'name',
		'email'
	],
	#classInstVars : [
		'savedInstance'
	],
	#category : #'OpenPonk-Github'
}

{ #category : #accessing }
OPGHAuthor class >> deleteSavedInstance [
	savedInstance := nil.
]

{ #category : #accessing }
OPGHAuthor class >> getInstance [
	^ savedInstance ifNil: [ ^ self new. ].
]

{ #category : #accessing }
OPGHAuthor class >> hasSavedInstance [
	^ savedInstance notNil.
]

{ #category : #accessing }
OPGHAuthor class >> savedInstance [
	^ savedInstance.
]

{ #category : #accessing }
OPGHAuthor class >> savedInstance: aInstance [
	 savedInstance := aInstance.
]

{ #category : #initialization }
OPGHAuthor class >> withName: aName withEmail: aEmail [
	| instance |
	instance := self new.
	^ instance name: aName;
		email: aEmail.
]

{ #category : #access }
OPGHAuthor >> email [
	^ email.
]

{ #category : #access }
OPGHAuthor >> email: aString [
	email := aString.
]

{ #category : #access }
OPGHAuthor >> name [
	^ name.
]

{ #category : #access }
OPGHAuthor >> name: aString [
	name := aString.
]

{ #category : #access }
OPGHAuthor >> valid [
	^ self validName and: [ self validEmail ].
]

{ #category : #access }
OPGHAuthor >> validEmail [
	^ email ~= '' and: [ email includes: '@'. ].
]

{ #category : #access }
OPGHAuthor >> validName [
	^ name ~= ''.
]
