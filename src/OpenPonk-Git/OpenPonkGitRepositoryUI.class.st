Class {
	#name : 'OpenPonkGitRepositoryUI',
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
	#category : 'OpenPonk-Git',
	#package : 'OpenPonk-Git'
}

{ #category : 'layout' }
OpenPonkGitRepositoryUI class >> addItemsTo: aLayout [

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
OpenPonkGitRepositoryUI class >> defaultLayout [

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
OpenPonkGitRepositoryUI class >> labelsWidth [

	^ 180
]

{ #category : 'as yet unclassified' }
OpenPonkGitRepositoryUI >> checkAllFilled [

	textToken text trim ifEmpty: [ ^ buttonConfirm disable ].
	textRepository text trim ifEmpty: [ ^ buttonConfirm disable ].
	textBranch text trim ifEmpty: [ ^ buttonConfirm disable ].
	buttonConfirm enable
]

{ #category : 'accessing' }
OpenPonkGitRepositoryUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : 'initialization' }
OpenPonkGitRepositoryUI >> connectPresenters [

	super connectPresenters.
	buttonConfirm action: [ 
		onConfirm value.
		self window delete ].
	buttonCancel action: [ self window delete ].

	textToken whenTextChangedDo: [ self checkAllFilled ].
	textRepository whenTextChangedDo: [ self checkAllFilled ].
	textBranch whenTextChangedDo: [ self checkAllFilled ].
	self checkAllFilled
]

{ #category : 'initialization' }
OpenPonkGitRepositoryUI >> initialize [

	onConfirm := [  ].
	super initialize
]

{ #category : 'initialization' }
OpenPonkGitRepositoryUI >> initializeButtons [
	buttonConfirm := self newButton.
	buttonCancel := self newButton.
	buttonConfirm 
		label: 'Confirm'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : 'initialization' }
OpenPonkGitRepositoryUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : 'initialization' }
OpenPonkGitRepositoryUI >> initializeFocusOrder [

	self subclassResponsibility
]

{ #category : 'initialization' }
OpenPonkGitRepositoryUI >> initializeLabels [

	labelToken := self newLabel.
	labelBranch := self newLabel.
	labelSave := self newLabel.
	labelRepository := self newLabel.

	labelToken label: 'Personal access token'.
	labelBranch label: 'Branch name'.
	labelSave label: 'Save token and repo?'.
	labelRepository label: 'Repository name'
]

{ #category : 'as yet unclassified' }
OpenPonkGitRepositoryUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : 'initialization' }
OpenPonkGitRepositoryUI >> initializeTextBoxes [

	textToken := self newTextInput.
	textBranch := self newTextInput.
	textRepository := self newTextInput.
	textRepository placeholder: 'owner/repository'
]

{ #category : 'accessing' }
OpenPonkGitRepositoryUI >> model [
	^ model
]

{ #category : 'accessing' }
OpenPonkGitRepositoryUI >> model: anObject [
	model := anObject
]

{ #category : 'enumerating' }
OpenPonkGitRepositoryUI >> onConfirmDo: aBlock [

	onConfirm := aBlock
]

{ #category : 'accessing' }
OpenPonkGitRepositoryUI >> textBranch [
	^ textBranch
]

{ #category : 'accessing' }
OpenPonkGitRepositoryUI >> textRepository [
	^ textRepository
]

{ #category : 'accessing' }
OpenPonkGitRepositoryUI >> textToken [
	^ textToken
]
