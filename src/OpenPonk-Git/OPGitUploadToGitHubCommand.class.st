"
A model command that serializes and pushes the current OpenPonk project and diagram preview to a GitHub repository.
"
Class {
	#name : 'OPGitUploadToGitHubCommand',
	#superclass : 'OPGitCommand',
	#category : 'OpenPonk-Git-Commands',
	#package : 'OpenPonk-Git',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPGitUploadToGitHubCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPGitMenuGroup
		order: 10
		for: OPEditor
]

{ #category : 'accessing' }
OPGitUploadToGitHubCommand >> defaultMenuIcon [
	"Answers the GitHub icon."
	^ self iconNamed: #github
]

{ #category : 'accessing' }
OPGitUploadToGitHubCommand >> defaultMenuItemName [
	"Answers the display name of the GitHub upload command."
	^ 'Upload project to GitHub'
]

{ #category : 'execution' }
OPGitUploadToGitHubCommand >> execute [
	"Starts the commit and upload process to GitHub."
	(OpenPonkGithub
		withProject: self projectController
		withDiagram: self editor canvasPresenter) startCommitProcess
]
