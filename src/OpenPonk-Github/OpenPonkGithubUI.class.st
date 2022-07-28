Class {
	#name : #OpenPonkGithubUI,
	#superclass : #SpPresenter,
	#category : #'OpenPonk-Github'
}

{ #category : #'as yet unclassified' }
OpenPonkGithubUI class >> defaultLayout [
]

{ #category : #toolbar }
OpenPonkGithubUI class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| appliedProfiles |
	appliedProfiles := aBuilder model diagramController model
		                   profileApplications collect: #appliedProfile.
	(appliedProfiles noneSatisfy: [ :each | each name = 'OntoUML' ]) 
		ifTrue: [ ^ self ].
	self toolbarMenuItemsFor: aBuilder
]

{ #category : #toolbar }
OpenPonkGithubUI class >> toolbarMenuItemsFor: aBuilder [

	(aBuilder item: 'Upload project to GitHub')
		icon: OntoUMLIcons ontoumlIcon;
		action: [ 
			(OpenPonkGithub
				 withProject: aBuilder model workbench projectController
				 withDiagram: aBuilder model canvasPresenter) startCommitProcess ].
	(aBuilder item: 'Download project from GitHub')
		icon: OntoUMLIcons ontoumlIcon;
		action: [ OpenPonkGithub new startFetchProcess ]
]

{ #category : #'as yet unclassified' }
OpenPonkGithubUI >> initializePresenters [
	"We don't need to initialize anything."
]
