"
A model command that serializes and pushes the current OpenPonk project and diagram preview to a GitLab repository.
"
Class {
	#name : 'OPGitUploadToGitLabCommand',
	#superclass : 'OPGitCommand',
	#category : 'OpenPonk-Git-Commands',
	#package : 'OpenPonk-Git',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPGitUploadToGitLabCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPGitMenuGroup
		order: 30
		for: OPEditor
]

{ #category : 'accessing' }
OPGitUploadToGitLabCommand >> defaultMenuIcon [
	"Answers the GitLab icon."
	^ self iconNamed: #gitlab
]

{ #category : 'accessing' }
OPGitUploadToGitLabCommand >> defaultMenuItemName [
	"Answers the display name of the GitLab upload command."
	^ 'Upload project to GitLab.com'
]

{ #category : 'execution' }
OPGitUploadToGitLabCommand >> execute [
	"Starts the commit and upload process to GitLab."
	(OpenPonkGitlab
		withProject: self projectController
		withDiagram: self editor canvasPresenter) startCommitProcess
]
