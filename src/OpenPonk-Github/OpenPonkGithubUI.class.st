Class {
	#name : #OpenPonkGithubUI,
	#superclass : #ComposablePresenter,
	#category : #'OpenPonk-Github'
}

{ #category : #specs }
OpenPonkGithubUI class >> defaultSpec [
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
		action: [ (OpenPonkGithub withProject: aBuilder model workbench projectController withDiagram: aBuilder model canvasModel) startCommitProcess. ].
	(aBuilder item: 'Download project from GitHub')
		action: [ OpenPonkGithub new startFetchProcess. ].
]

{ #category : #initialization }
OpenPonkGithubUI >> initializeWidgets [
	"We don't need to initialize anything."
]
