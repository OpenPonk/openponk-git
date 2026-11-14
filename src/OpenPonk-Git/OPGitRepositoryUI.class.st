"
I am the abstract base Spec presenter for capturing Git repository connection details from the user, including the repository URL, branch name, and authentication token.
"
Class {
	#name : 'OPGitRepositoryUI',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'labelRepository',
		'labelBranch',
		'labelSave',
		'textRepository',
		'textBranch',
		'buttonCancel',
		'checkBoxSave',
		'buttonConfirm',
		'onConfirm',
		'labelToken',
		'textToken'
	],
	#category : 'OpenPonk-Git-GUI',
	#package : 'OpenPonk-Git',
	#tag : 'GUI'
}

{ #category : 'layout' }
OPGitRepositoryUI class >> addItemsTo: aLayout [

	aLayout
		add: (SpBoxLayout newLeftToRight
				 spacing: 5;
				 add: #labelToken width: self labelsWidth;
				 add: #textToken;
				 yourself);
		add: (SpBoxLayout newLeftToRight
				 spacing: 5;
				 add: #labelRepository width: self labelsWidth;
				 add: #textRepository;
				 yourself);
		add: (SpBoxLayout newLeftToRight
				 spacing: 5;
				 add: #labelBranch width: self labelsWidth;
				 add: #textBranch;
				 yourself);
		add: (SpBoxLayout newLeftToRight
				 spacing: 5;
				 add: #labelSave width: self labelsWidth;
				 add: #checkBoxSave;
				 yourself)
]

{ #category : 'layout' }
OPGitRepositoryUI class >> defaultLayout [

	| innerLayout |
	innerLayout := SpBoxLayout newTopToBottom.
	self addItemsTo: innerLayout.
	innerLayout add: (SpBoxLayout newLeftToRight
			 spacing: 5;
			 hAlignEnd;
			 add: #buttonCancel expand: false;
			 add: #buttonConfirm expand: false;
			 yourself).
	^ innerLayout
]

{ #category : 'layout' }
OPGitRepositoryUI class >> labelsWidth [

	^ 180
]

{ #category : 'updating' }
OPGitRepositoryUI >> checkAllFilled [

	textToken text trim ifEmpty: [ ^ buttonConfirm disable ].
	textRepository text trim ifEmpty: [ ^ buttonConfirm disable ].
	textBranch text trim ifEmpty: [ ^ buttonConfirm disable ].
	buttonConfirm enable
]

{ #category : 'accessing' }
OPGitRepositoryUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : 'initialization' }
OPGitRepositoryUI >> connectPresenters [

	super connectPresenters.
	buttonConfirm action: [
		onConfirm value.
		self window close ].
	buttonCancel action: [ self window close ].

	textToken whenTextChangedDo: [ self checkAllFilled ].
	textRepository whenTextChangedDo: [ self checkAllFilled ].
	textBranch whenTextChangedDo: [ self checkAllFilled ].
	self checkAllFilled
]

{ #category : 'initialization' }
OPGitRepositoryUI >> initialize [

	onConfirm := [  ].
	super initialize
]

{ #category : 'initialization' }
OPGitRepositoryUI >> initializeButtons [
	buttonConfirm := self newButton.
	buttonCancel := self newButton.
	buttonConfirm 
		label: 'Confirm'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : 'initialization' }
OPGitRepositoryUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : 'initialization' }
OPGitRepositoryUI >> initializeFocusOrder [

	self subclassResponsibility
]

{ #category : 'initialization' }
OPGitRepositoryUI >> initializeLabels [

	labelToken := self newLabel.
	labelBranch := self newLabel.
	labelSave := self newLabel.
	labelRepository := self newLabel.

	labelToken label: 'Personal access token'.
	labelBranch label: 'Branch name'.
	labelSave label: 'Save token and repo?'.
	labelRepository label: 'Repository name'
]

{ #category : 'initialization' }
OPGitRepositoryUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : 'initialization' }
OPGitRepositoryUI >> initializeTextBoxes [

	textToken := self newTextInput.
	textBranch := self newTextInput.
	textRepository := self newTextInput.
	textRepository placeholder: 'owner/repository'
]

{ #category : 'accessing' }
OPGitRepositoryUI >> model [
	^ model
]

{ #category : 'accessing' }
OPGitRepositoryUI >> model: anObject [
	model := anObject
]

{ #category : 'enumerating' }
OPGitRepositoryUI >> onConfirmDo: aBlock [

	onConfirm := aBlock
]

{ #category : 'accessing' }
OPGitRepositoryUI >> textBranch [
	^ textBranch
]

{ #category : 'accessing' }
OPGitRepositoryUI >> textRepository [
	^ textRepository
]

{ #category : 'accessing' }
OPGitRepositoryUI >> textToken [
	^ textToken
]
