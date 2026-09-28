"
A model command that fetches and imports an OpenPonk project directly from a GitHub repository.
"
Class {
	#name : 'OPGitDownloadFromGitHubCommand',
	#superclass : 'OPGitCommand',
	#category : 'OpenPonk-Git-Commands',
	#package : 'OpenPonk-Git',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPGitDownloadFromGitHubCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPGitMenuGroup
		order: 20
		for: OPEditor
]

{ #category : 'accessing' }
OPGitDownloadFromGitHubCommand >> defaultMenuIcon [
	"Answers the GitHub icon."
	^ self iconNamed: #github
]

{ #category : 'accessing' }
OPGitDownloadFromGitHubCommand >> defaultMenuItemName [
	"Answers the display name of the GitHub download command."
	^ 'Download project from GitHub'
]

{ #category : 'execution' }
OPGitDownloadFromGitHubCommand >> execute [
	"Starts the download and fetch process from GitHub."
	(OpenPonkGithub withSpApplication: self editor application) startFetchProcess
]
