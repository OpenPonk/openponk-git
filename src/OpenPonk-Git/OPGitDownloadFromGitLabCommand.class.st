"
A model command that fetches and imports an OpenPonk project directly from a GitLab repository.
"
Class {
	#name : 'OPGitDownloadFromGitLabCommand',
	#superclass : 'OPGitCommand',
	#category : 'OpenPonk-Git-Commands',
	#package : 'OpenPonk-Git',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPGitDownloadFromGitLabCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPGitMenuGroup
		order: 40
		for: OPEditor
]

{ #category : 'accessing' }
OPGitDownloadFromGitLabCommand >> defaultMenuIcon [
	"Answers the GitLab icon."
	^ self iconNamed: #gitlab
]

{ #category : 'accessing' }
OPGitDownloadFromGitLabCommand >> defaultMenuItemName [
	"Answers the display name of the GitLab download command."
	^ 'Download project from GitLab.com'
]

{ #category : 'execution' }
OPGitDownloadFromGitLabCommand >> execute [
	"Starts the download and fetch process from GitLab."
	(OpenPonkGitlab withSpApplication: self editor application) startFetchProcess
]
