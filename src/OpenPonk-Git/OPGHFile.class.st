Class {
	#name : #OPGHFile,
	#superclass : #Object,
	#instVars : [
		'blobSha',
		'path',
		'localDirectoryOfPath',
		'content',
		'encoding'
	],
	#category : #'OpenPonk-Git'
}

{ #category : #navigating }
OPGHFile class >> withPath: aPath relativeTo: aLocalDirectoryPath [

	| file |
	file := self new.
	file
		path: aPath;
		localDirectoryOfPath: aLocalDirectoryPath.
	^ file
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

	^ content ifNil: [ 
		  content := self localPath asFileReference binaryReadStream
			             contents base64Encoded ]
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
	^ path asPath extension
]

{ #category : #fileout }
OPGHFile >> localDirectoryOfPath: aDirectoryPath [

	localDirectoryOfPath := aDirectoryPath
]

{ #category : #accessing }
OPGHFile >> localPath [

	^ (localDirectoryOfPath asPath / path) pathString
]

{ #category : #accessing }
OPGHFile >> path [

	^ path
]

{ #category : #accessing }
OPGHFile >> path: aPathString [
	path := aPathString.
]

{ #category : #fileout }
OPGHFile >> saveBinary [

	| file |
	file := self localPath asFileReference.
	file parent ensureCreateDirectory.
	file binaryWriteStreamDo: [ :stream | 
		stream nextPutAll: content base64Decoded ]
]

{ #category : #fileout }
OPGHFile >> saveText [

	| file |
	file := self localPath asFileReference.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :stream | 
		stream
			truncate;
			nextPutAll: content ]
]

{ #category : #fileout }
OPGHFile >> saveTo: aDirectoryPath [

	self localDirectoryOfPath: aDirectoryPath.
	encoding = 'base64'
		ifTrue: [ self saveBinary ]
		ifFalse: [ self saveText ].
	^ self localPath
]
