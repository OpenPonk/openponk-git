"
An abstract base class for Commander 1 model commands that interface with remote Git repositories (GitHub, GitLab).
"
Class {
	#name : 'OPGitCommand',
	#superclass : 'OPModelCommand',
	#category : 'OpenPonk-Git-Commands',
	#package : 'OpenPonk-Git',
	#tag : 'Commands'
}

{ #category : 'testing' }
OPGitCommand class >> canBeExecutedInEditor: anEditor [
	"Answers true if the active editor has an initialized diagram controller."
	^ self isAbstract not and: [ anEditor diagramController isNotNil ]
]

{ #category : 'testing' }
OPGitCommand class >> isAbstract [
	"Answers true if this class is the abstract root of Git model commands."
	^ self = OPGitCommand
]
