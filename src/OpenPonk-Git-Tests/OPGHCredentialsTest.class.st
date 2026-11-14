"
Unit tests for Git access token storage and singleton persistence.
"
Class {
	#name : 'OPGHCredentialsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Git-Tests-Model',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
OPGHCredentialsTest >> tearDown [
	OPGHCredentials deleteSavedInstance.
	super tearDown
]

{ #category : 'tests' }
OPGHCredentialsTest >> testTokenAndSingletonLifecycle [
	| credentials |
	OPGHCredentials deleteSavedInstance.
	credentials := OPGHCredentials getInstance.
	credentials token: 'secret-token'.
	self assert: credentials token equals: 'secret-token'.

	OPGHCredentials savedInstance: credentials.
	self assert: OPGHCredentials savedInstance identicalTo: credentials.
	OPGHCredentials deleteSavedInstance.
	self assert: OPGHCredentials savedInstance identicalTo: nil
]
