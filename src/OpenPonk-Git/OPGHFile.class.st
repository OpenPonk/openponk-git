Class {
	#name : #OPGHFile,
	#superclass : #Object,
	#instVars : [
		'blobSha',
		'pathInRepo',
		'localFile',
		'content',
		'encoding'
	],
	#category : #'OpenPonk-Git'
}

{ #category : #navigating }
OPGHFile class >> withPath: aPath file: aFileReference [

	^ self new
		  pathInRepo: aPath;
		  localFile: aFileReference;
		  yourself
]

{ #category : #navigating }
OPGHFile class >> withPath: aPath withSha: aBlobSha [

	| file |
	file := self new.
	file pathInRepo: aPath.
	file blobSha: aBlobSha.
	^ file
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
		  content := localFile asFileReference binaryReadStream contents
			             base64Encoded ]
]

{ #category : #accessing }
OPGHFile >> contentDecoded [

	^ content base64Decoded asString
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
	^ localFile asPath extension
]

{ #category : #accessing }
OPGHFile >> localFile [

	^ localFile ifNil: [ self pathInRepo asFileReference ]
]

{ #category : #accessing }
OPGHFile >> localFile: anObject [

	localFile := anObject
]

{ #category : #accessing }
OPGHFile >> localFileIn: aDirectory [

	self assert: self pathInRepo isNotNil.
	self localFile: aDirectory / self pathInRepo
]

{ #category : #accessing }
OPGHFile >> pathInRepo [

	^ pathInRepo
]

{ #category : #accessing }
OPGHFile >> pathInRepo: aPathString [

	pathInRepo := aPathString
]

{ #category : #fileout }
OPGHFile >> saveBinary [

	| file |
	file := localFile asFileReference.
	file parent ensureCreateDirectory.
	file binaryWriteStreamDo: [ :stream | 
		stream nextPutAll: content base64Decoded ]
]

{ #category : #fileout }
OPGHFile >> saveText [

	| file |
	file := localFile asFileReference.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :stream | 
		stream
			truncate;
			nextPutAll: content ]
]

{ #category : #fileout }
OPGHFile >> saveTo: aDirectoryPath [

	self localFileIn: aDirectoryPath.
	encoding = 'base64'
		ifTrue: [ self saveBinary ]
		ifFalse: [ self saveText ].
	^ localFile
]
