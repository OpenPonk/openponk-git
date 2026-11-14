"
Unit tests for repository file encoding, decoding, path resolution, and file output.
"
Class {
	#name : 'OPGHFileTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Git-Tests-Model',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
OPGHFileTest >> testEncodingDecodingAndFileSaving [
	| memRoot sourceFile file binaryTarget writtenBytes textFile textTarget blobFile |
	memRoot := FileSystem memory root.
	sourceFile := memRoot / 'model.opp'.
	sourceFile binaryWriteStreamDo: [ :stream | stream nextPutAll: #[1 2 3 4] ].

	file := OPGHFile withPath: 'sub/model.opp' file: sourceFile.
	self assert: file pathInRepo equals: 'sub/model.opp'.
	self assert: file extension equals: 'opp'.
	self assert: file contentBase64 equals: #[1 2 3 4] base64Encoded.
	self assert: file binaryContent equals: #[1 2 3 4].

	binaryTarget := memRoot / 'out-bin'.
	file encoding: 'base64'.
	file saveTo: binaryTarget.
	writtenBytes := (binaryTarget / 'sub/model.opp') binaryReadStreamDo: [ :stream | stream upToEnd ].
	self assert: writtenBytes equals: #[1 2 3 4].

	textFile := OPGHFile withPath: 'notes.txt' withSha: 'abc123'.
	self assert: textFile blobSha equals: 'abc123'.
	self assert: textFile localFile equals: 'notes.txt' asFileReference.
	textFile content: 'Hello OpenPonk'.
	textFile encoding: 'utf-8'.
	textTarget := memRoot / 'out-txt'.
	textFile saveTo: textTarget.
	self assert: (textTarget / 'notes.txt') contents equals: 'Hello OpenPonk'.

	blobFile := OPGHFile withPath: 'data.json' withSha: 'def456'.
	blobFile content: '{"ok":true}' utf8Encoded base64Encoded.
	self assert: blobFile contentDecoded equals: '{"ok":true}'
]
