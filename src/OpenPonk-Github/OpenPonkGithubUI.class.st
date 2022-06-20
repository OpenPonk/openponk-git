Class {
	#name : #OpenPonkGithubUI,
	#superclass : #SpPresenter,
	#category : #'OpenPonk-Github'
}

{ #category : #'as yet unclassified' }
OpenPonkGithubUI class >> defaultLayout [
]

{ #category : #specs }
OpenPonkGithubUI class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
]

{ #category : #toolbar }
OpenPonkGithubUI class >> toolbarMenu: aBuilder [ 
	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| builder |
	builder := aBuilder model diagramController model profileApplications.
	(builder isEmpty or: [ builder anyOne appliedProfile name ~= 'OntoUML' ])
		ifTrue: [ ^ self ].
	self toolbarMenuItemsFor: aBuilder
]

{ #category : #toolbar }
OpenPonkGithubUI class >> toolbarMenuItemsFor: aBuilder [
	(aBuilder item: 'Upload project to GitHub')
		action: [ (OpenPonkGithub withProject: aBuilder model workbench projectController withDiagram: aBuilder model canvasPresenter) startCommitProcess. ].
	(aBuilder item: 'Download project from GitHub')
		action: [ OpenPonkGithub new startFetchProcess. ].
]

{ #category : #'as yet unclassified' }
OpenPonkGithubUI >> initializePresenters [
	"We don't need to initialize anything."
]
