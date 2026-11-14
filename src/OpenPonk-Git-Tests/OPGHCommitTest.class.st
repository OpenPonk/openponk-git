"
Unit tests for Git commit metadata defaults and singleton persistence.
"
Class {
	#name : 'OPGHCommitTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Git-Tests-Model',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
OPGHCommitTest >> tearDown [
	OPGHCommit deleteSavedInstance.
	super tearDown
]

{ #category : 'tests' }
OPGHCommitTest >> testDefaultsAccessorsAndSingletonLifecycle [
	| commit |
	OPGHCommit deleteSavedInstance.
	commit := OPGHCommit getInstance.
	self assert: commit branch equals: 'master'.

	commit
		repository: 'openponk/openponk';
		branch: 'develop';
		message: 'Initial commit'.
	self assert: commit repository equals: 'openponk/openponk'.
	self assert: commit branch equals: 'develop'.
	self assert: commit message equals: 'Initial commit'.

	OPGHCommit savedInstance: commit.
	self assert: OPGHCommit savedInstance identicalTo: commit.
	OPGHCommit deleteSavedInstance.
	self assert: OPGHCommit savedInstance identicalTo: nil
]
