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
OPGitModelMenuTest >> testGitSubMenuContainsAllGitCommandsWhenEditorHasDiagramController [
	"Verifies that Git model repository submenu contains all 4 git items when active editor has an initialized diagram controller."
	| testEditor modelMenuItem gitItems gitItemNames |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.
	testEditor openEmptyModel: OPTestContainerModel new.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	gitItems := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems select: [ :eachItem | eachItem name = 'Git model repository' ] ].
	self assert: gitItems isNotEmpty.
	gitItemNames := gitItems first subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].
	self assertCollection: gitItemNames includesAll: #(
		'Upload project to GitHub'
		'Download project from GitHub'
		'Upload project to GitLab.com'
		'Download project from GitLab.com' )
]

{ #category : 'tests' }
OPGitModelMenuTest >> testGitSubMenuIsAbsentWhenEditorHasNoDiagramController [
	"Verifies that Git model repository submenu is omitted when active editor has no diagram controller."
	| testEditor modelMenuItem gitItems |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	gitItems := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems select: [ :eachItem | eachItem name = 'Git model repository' ] ].
	self assert: gitItems isEmpty
]
