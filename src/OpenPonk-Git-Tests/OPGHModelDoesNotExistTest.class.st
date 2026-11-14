"
Unit tests for missing repository model exception formatting and signaling.
"
Class {
	#name : 'OPGHModelDoesNotExistTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Git-Tests-Model',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
OPGHModelDoesNotExistTest >> testMessageTextAndSignaling [
	| defaultError |
	defaultError := OPGHModelDoesNotExist new.
	self assert: defaultError messageText equals: 'There is no such model in the repository.'.

	[ OPGHModelDoesNotExist signalModel: 'borm-demo' ]
		on: OPGHModelDoesNotExist
		do: [ :ex |
			self assert: ex messageText equals: 'There is no model named "borm-demo" in the repository.' ]
]
