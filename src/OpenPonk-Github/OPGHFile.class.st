Class {
	#name : #OPGHFile,
	#superclass : #Object,
	#instVars : [
		'blobSha',
		'path',
		'directory',
		'name',
		'content',
		'encoding'
	],
	#category : #'OpenPonk-Github'
}

{ #category : #navigating }
OPGHFile class >> withPath: aPath [
	| file |
	file := self new.
	file path: aPath.
	^ file.
]

{ #category : #navigating }
OPGHFile class >> withPath: aPath withSha: aBlobSha [
	| file |
	file := self new.
	file path: aPath.
	file blobSha: aBlobSha.
	^ file.
]

{ #category : #accessing }
OPGHFile >> blobSha [
	^ blobSha.
]

{ #category : #accessing }
OPGHFile >> blobSha: aShaString [
	blobSha := aShaString.
]

{ #category : #accessing }
OPGHFile >> content: anObject [
	^ content := anObject
]

{ #category : #accessing }
OPGHFile >> contentBase64 [
	^ content ifNil: [ content := path asFileReference binaryReadStream contents base64Encoded].
]

{ #category : #accessing }
OPGHFile >> contentBase64: aBase64String [
	content := aBase64String.
	encoding := 'base64'
]

{ #category : #accessing }
OPGHFile >> directory [
	^ directory.
]

{ #category : #accessing }
OPGHFile >> directory: aString [
	directory := aString.
]

{ #category : #accessing }
OPGHFile >> encoding [
	^ encoding.
]

{ #category : #accessing }
OPGHFile >> encoding: aString [
	encoding := aString.
]

{ #category : #accessing }
OPGHFile >> extension [
	^ name ifNil: [ ^ (path substrings: '.') last ] ifNotNil: [^ (name substrings: '.') last  ].
]

{ #category : #accessing }
OPGHFile >> name [
	^ name ifNil: [name:=(path substrings: '\') last].
]

{ #category : #accessing }
OPGHFile >> name: aString [
	name := aString.
]

{ #category : #accessing }
OPGHFile >> path [
	^ path ifNil: [path := directory , '/' , name].
]

{ #category : #accessing }
OPGHFile >> path: aPathString [
	path := aPathString.
]

{ #category : #fileout }
OPGHFile >> saveBinaryTo: aFileName [
	aFileName asFileReference binaryWriteStreamDo: [ :stream | 
    stream
        nextPutAll: content base64Decoded ].
]

{ #category : #fileout }
OPGHFile >> saveTextTo: aFileName [
	aFileName asFileReference writeStreamDo: [ :stream | 
    stream truncate;
        nextPutAll: content ].
]

{ #category : #fileout }
OPGHFile >> saveTo: aDirectoryPath [

	| localFilePath |
	localFilePath := aDirectoryPath , '\' , path.
	encoding = 'base64'
		ifTrue: [ self saveBinaryTo: localFilePath ]
		ifFalse: [ self saveTextTo: localFilePath ].
	^ localFilePath
]
