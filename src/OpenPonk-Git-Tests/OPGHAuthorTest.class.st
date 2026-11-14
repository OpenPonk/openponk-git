"
Unit tests for Git author metadata validation and singleton persistence.
"
Class {
	#name : 'OPGHAuthorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Git-Tests-Model',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
OPGHAuthorTest >> tearDown [
	OPGHAuthor deleteSavedInstance.
	super tearDown
]

{ #category : 'tests' }
OPGHAuthorTest >> testValidationAndSingletonLifecycle [
	| author |
	OPGHAuthor deleteSavedInstance.
	self assert: OPGHAuthor savedInstance identicalTo: nil.

	author := OPGHAuthor getInstance.
	self deny: author valid description: 'Uninitialized author must not be valid'.

	author name: 'Jane Doe'.
	author email: 'invalid-email'.
	self deny: author validEmail description: 'Email without @ must be invalid'.
	self deny: author valid description: 'Author with invalid email must not be valid'.

	author email: 'jane@example.com'.
	self assert: author validName description: 'Non-empty name must be valid'.
	self assert: author validEmail description: 'Email with @ must be valid'.
	self assert: author valid description: 'Author with valid name and email must be valid'.

	OPGHAuthor savedInstance: author.
	self assert: OPGHAuthor savedInstance identicalTo: author.
	OPGHAuthor deleteSavedInstance.
	self assert: OPGHAuthor savedInstance identicalTo: nil
]
