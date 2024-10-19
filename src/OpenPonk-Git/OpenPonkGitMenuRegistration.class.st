Class {
	#name : 'OpenPonkGitMenuRegistration',
	#superclass : 'Object',
	#category : 'OpenPonk-Git',
	#package : 'OpenPonk-Git'
}

{ #category : 'toolbar' }
OpenPonkGitMenuRegistration class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| appliedProfiles |
	appliedProfiles := aBuilder model diagramController model
		                   profileApplications collect: #appliedProfile.
	(appliedProfiles noneSatisfy: [ :each | each name = 'OntoUML' ]) 
		ifTrue: [ ^ self ].
	self toolbarMenuItemsFor: aBuilder
]

{ #category : 'toolbar' }
OpenPonkGitMenuRegistration class >> toolbarMenuItemsFor: aBuilder [

	| uploadBlock downloadBlock |
	uploadBlock := [ :class |
	               (class
		                withProject:
		                aBuilder model workbench projectController
		                withDiagram: aBuilder model canvasPresenter)
		               startCommitProcess ].
	downloadBlock := [ :class |
	                 (class withSpApplication: aBuilder model application) startFetchProcess ].
	(aBuilder item: #opgit)
		action: [  ];
		label: 'Git model repository';
		iconName: #git.
	(aBuilder item: 'Upload project to GitHub')
		parent: #opgit;
		iconName: #github;
		action: [ uploadBlock value: OpenPonkGithub ].
	(aBuilder item: 'Download project from GitHub')
		parent: #opgit;
		iconName: #github;
		action: [ downloadBlock value: OpenPonkGithub ].
	(aBuilder item: 'Upload project to GitLab.com')
		parent: #opgit;
		iconName: #gitlab;
		action: [ uploadBlock value: OpenPonkGitlab ].
	(aBuilder item: 'Download project from GitLab.com')
		parent: #opgit;
		iconName: #gitlab;
		action: [ downloadBlock value: OpenPonkGitlab ]
]
