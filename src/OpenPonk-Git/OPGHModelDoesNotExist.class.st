Class {
	#name : #OPGHModelDoesNotExist,
	#superclass : #Error,
	#instVars : [
		'name'
	],
	#category : #'OpenPonk-Git'
}

{ #category : #'instance creation' }
OPGHModelDoesNotExist class >> signalModel: aString [

	self new
		name: aString;
		signal
]

{ #category : #accessing }
OPGHModelDoesNotExist >> messageText [

	^ messageText ifNil: [ 
		  name
			  ifNil: [ 'There is no such model in the repository.' ]
			  ifNotNil: [ 
			  'There is no model named "' , name , '" in the repository.' ] ]
]

{ #category : #accessing }
OPGHModelDoesNotExist >> name: aString [ 
	name := aString
]
