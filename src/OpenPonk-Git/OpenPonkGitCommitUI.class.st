Class {
	#name : #OpenPonkGitCommitUI,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'labelRepository',
		'labelBranch',
		'labelSave',
		'labelMsg',
		'textRepository',
		'textBranch',
		'textMsg',
		'buttonCommit',
		'buttonCancel',
		'checkBoxSave'
	],
	#category : #'OpenPonk-Git'
}

{ #category : #'as yet unclassified' }
OpenPonkGitCommitUI class >> defaultLayout [

	| labelsWidth |
	labelsWidth := 180.
	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #labelRepository width: labelsWidth;
				   add: #textRepository;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #labelBranch width: labelsWidth;
				   add: #textBranch;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #labelSave width: labelsWidth;
				   add: #checkBoxSave;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #labelMsg width: labelsWidth;
				   add: #textMsg;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   hAlignEnd;
				   add: #buttonCancel expand: false;
				   add: #buttonCommit expand: false;
				   yourself);
		  yourself
]

{ #category : #accessing }
OpenPonkGitCommitUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGitCommitUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> buttonCommit [
	^ buttonCommit
]

{ #category : #accessing }
OpenPonkGitCommitUI >> buttonCommit: anObject [
	buttonCommit := anObject
]

{ #category : #'as yet unclassified' }
OpenPonkGitCommitUI >> checkAllFilled [

	textRepository text trim ifEmpty: [ ^ buttonCommit disable ].
	textBranch text trim ifEmpty: [ ^ buttonCommit disable ].
	textMsg text trim ifEmpty: [ ^ buttonCommit disable ].
	buttonCommit enable
]

{ #category : #accessing }
OpenPonkGitCommitUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : #accessing }
OpenPonkGitCommitUI >> checkBoxSave: anObject [
	checkBoxSave := anObject
]

{ #category : #'as yet unclassified' }
OpenPonkGitCommitUI >> connectPresenters [

	buttonCommit action: [ 
		self model commitSet: self.
		self window delete ].
	buttonCancel action: [ self window delete ].
	textRepository whenTextChangedDo: [ self checkAllFilled ].
	textBranch whenTextChangedDo: [ self checkAllFilled ].
	textMsg whenTextChangedDo: [ self checkAllFilled ].
	self checkAllFilled
]

{ #category : #initialization }
OpenPonkGitCommitUI >> initializeButtons [
	buttonCommit := self newButton.
	buttonCancel := self newButton.
	buttonCommit 
		label: 'Commit'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGitCommitUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGitCommitUI >> initializeFocusOrder [
	self focusOrder 
		add: textRepository;
		add: textBranch;
		add: checkBoxSave;
		add: textMsg;
		add: buttonCommit;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGitCommitUI >> initializeLabels [
	labelBranch := self newLabel.	
	labelSave  := self newLabel.	
	labelRepository  := self newLabel.	
	labelMsg := self newLabel.	
	
	labelBranch label: 'Branch name'.
	labelSave label: 'Save repository and branch?'.
	labelRepository label: 'Repository name'.
	labelMsg  label: 'Commit message'.
	
]

{ #category : #'as yet unclassified' }
OpenPonkGitCommitUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #initialization }
OpenPonkGitCommitUI >> initializeTextBoxes [

	textBranch := self newTextInput.
	textRepository := self newTextInput.
	textRepository placeholder: 'owner/repository'.
	textMsg := self newTextInput
]

{ #category : #api }
OpenPonkGitCommitUI >> initializeWindow: aWindow [

	aWindow
		initialExtent: 450 @ 184;
		title: 'Commit form'
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelBranch [
	^ labelBranch
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelBranch: anObject [
	labelBranch := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelMsg [
	^ labelMsg
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelMsg: anObject [
	labelMsg := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelRepository [
	^ labelRepository
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelRepository: anObject [
	labelRepository := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGitCommitUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> model [
	^ model
]

{ #category : #accessing }
OpenPonkGitCommitUI >> model: anObject [
	model := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> textBranch [
	^ textBranch
]

{ #category : #accessing }
OpenPonkGitCommitUI >> textBranch: anObject [
	textBranch := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> textMsg [
	^ textMsg
]

{ #category : #accessing }
OpenPonkGitCommitUI >> textMsg: anObject [
	textMsg := anObject
]

{ #category : #accessing }
OpenPonkGitCommitUI >> textRepository [
	^ textRepository
]

{ #category : #accessing }
OpenPonkGitCommitUI >> textRepository: anObject [
	textRepository := anObject
]
