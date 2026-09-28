"
Verifies that Commander 1 Git model commands (GitHub/GitLab push and fetch) are properly activated and populated in the toolbar menu across all notations.
"
Class {
	#name : 'OPGitModelMenuTest',
	#superclass : 'TestCase',
	#instVars : [
		'toolbarPresenter',
		'mockWorkbench',
		'projectController'
	],
	#category : 'OpenPonk-Git-Tests',
	#package : 'OpenPonk-Git',
	#tag : 'Tests'
}

{ #category : 'running' }
OPGitModelMenuTest >> setUp [
	super setUp.
	projectController := OPProjectController new.
	projectController project: OPProject new.
	mockWorkbench := Mock new.
	mockWorkbench stub projectController willReturn: projectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	mockWorkbench stub announcer willReturn: Announcer new.
	toolbarPresenter := OPWorkbenchToolbar newApplication: SpApplication defaultApplication.
	toolbarPresenter owner: mockWorkbench
]

{ #category : 'running' }
OPGitModelMenuTest >> tearDown [
	toolbarPresenter := nil.
	mockWorkbench := nil.
	projectController := nil.
	super tearDown
]

{ #category : 'tests' }
OPGitModelMenuTest >> testGitSubMenuContainsAllGitCommandsInBpmnEditor [
	"Verifies that Git model repository submenu is present and active in BPMN editor."
	| bpmnPlugin testEditor modelMenuItem gitItems gitNames |
	bpmnPlugin := OPPluginRegistry default plugins
		detect: [ :eachPluginCandidate | eachPluginCandidate isKindOf: OPBPMNPlugin ].
	testEditor := (OPEditor on: bpmnPlugin)
		workbench: mockWorkbench;
		yourself.
	testEditor openEmptyModel: OPBPMNModel new.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	gitItems := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems select: [ :eachItem | eachItem name = 'Git model repository' ] ].
	self assert: gitItems isNotEmpty.
	gitNames := gitItems first subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].
	self assertCollection: gitNames includesAll: #(
		'Upload project to GitHub'
		'Download project from GitHub'
		'Upload project to GitLab.com'
		'Download project from GitLab.com' )
]

{ #category : 'tests' }
OPGitModelMenuTest >> testGitSubMenuContainsAllGitCommandsInGenericUmlEditor [
	"Verifies that Git model repository submenu contains all 4 git items in a generic UML editor."
	| umlPlugin testEditor modelMenuItem gitItems gitNames |
	umlPlugin := OPPluginRegistry default plugins
		detect: [ :eachPluginCandidate | eachPluginCandidate isKindOf: OPUmlClassEditorPlugin ].
	testEditor := (OPEditor on: umlPlugin)
		workbench: mockWorkbench;
		yourself.
	testEditor openEmptyModel: OPUMLPackage new.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	gitItems := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems select: [ :eachItem | eachItem name = 'Git model repository' ] ].
	self assert: gitItems isNotEmpty.
	gitNames := gitItems first subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].
	self assertCollection: gitNames includesAll: #(
		'Upload project to GitHub'
		'Download project from GitHub'
		'Upload project to GitLab.com'
		'Download project from GitLab.com' )
]

{ #category : 'tests' }
OPGitModelMenuTest >> testGitSubMenuContainsAllGitCommandsInPetriNetsEditor [
	"Verifies that Git model repository submenu is present and active in Petri Nets editor."
	| pnPlugin testEditor modelMenuItem gitItems gitNames |
	pnPlugin := OPPluginRegistry default plugins
		detect: [ :eachPluginCandidate | eachPluginCandidate isKindOf: OPPetriNetsPlugin ].
	testEditor := (OPEditor on: pnPlugin)
		workbench: mockWorkbench;
		yourself.
	testEditor openEmptyModel: OPPetriNet new.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	gitItems := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems select: [ :eachItem | eachItem name = 'Git model repository' ] ].
	self assert: gitItems isNotEmpty.
	gitNames := gitItems first subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].
	self assertCollection: gitNames includesAll: #(
		'Upload project to GitHub'
		'Download project from GitHub'
		'Upload project to GitLab.com'
		'Download project from GitLab.com' )
]
