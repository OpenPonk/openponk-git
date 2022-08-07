Class {
	#name : #OpenPonkGitFetchUI,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'labelRepository',
		'labelBranch',
		'labelSave',
		'textRepository',
		'textBranch',
		'buttonFetch',
		'buttonCancel',
		'checkBoxSave'
	],
	#category : #'OpenPonk-Git'
}

{ #category : #'as yet unclassified' }
OpenPonkGitFetchUI class >> defaultLayout [

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
				   hAlignEnd;
				   add: #buttonCancel expand: false;
				   add: #buttonFetch expand: false;
				   yourself);
		  yourself
]

{ #category : #accessing }
OpenPonkGitFetchUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGitFetchUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGitFetchUI >> buttonFetch [
	^ buttonFetch
]

{ #category : #accessing }
OpenPonkGitFetchUI >> buttonFetch: anObject [
	buttonFetch := anObject
]

{ #category : #accessing }
OpenPonkGitFetchUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : #accessing }
OpenPonkGitFetchUI >> checkBoxSave: anObject [
	checkBoxSave := anObject
]

{ #category : #'as yet unclassified' }
OpenPonkGitFetchUI >> connectPresenters [
	buttonFetch action: [ self model fetchRepositoryFilled: self.
		 self window delete. ].
	buttonCancel action: [ self window delete ].
]

{ #category : #api }
OpenPonkGitFetchUI >> extent [
	^ 600@250
]

{ #category : #initialization }
OpenPonkGitFetchUI >> initializeButtons [
	buttonFetch := self newButton.
	buttonCancel := self newButton.
	buttonFetch 
		label: 'Fetch'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGitFetchUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGitFetchUI >> initializeFocusOrder [
	self focusOrder 
		add: textRepository;
		add: textBranch;
		add: checkBoxSave;
		add: buttonFetch;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGitFetchUI >> initializeLabels [
	labelBranch := self newLabel.	
	labelSave  := self newLabel.	
	labelRepository  := self newLabel.	
	
	labelBranch label: 'Branch name'.
	labelSave label: 'Save repository and branch?'.
	labelRepository label: 'Repository name'.
]

{ #category : #'as yet unclassified' }
OpenPonkGitFetchUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #initialization }
OpenPonkGitFetchUI >> initializeTextBoxes [

	textBranch := self newTextInput.
	textRepository := self newTextInput.
	textRepository placeholder: 'owner/repository'
]

{ #category : #api }
OpenPonkGitFetchUI >> initializeWindow: aWindow [

	aWindow
		initialExtent: 520 @ 165;
		title: 'Repository form'
]

{ #category : #accessing }
OpenPonkGitFetchUI >> labelBranch [
	^ labelBranch
]

{ #category : #accessing }
OpenPonkGitFetchUI >> labelBranch: anObject [
	labelBranch := anObject
]

{ #category : #accessing }
OpenPonkGitFetchUI >> labelRepository [
	^ labelRepository
]

{ #category : #accessing }
OpenPonkGitFetchUI >> labelRepository: anObject [
	labelRepository := anObject
]

{ #category : #accessing }
OpenPonkGitFetchUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGitFetchUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGitFetchUI >> model [
	^ model
]

{ #category : #accessing }
OpenPonkGitFetchUI >> model: anObject [
	model := anObject
]

{ #category : #accessing }
OpenPonkGitFetchUI >> textBranch [
	^ textBranch
]

{ #category : #accessing }
OpenPonkGitFetchUI >> textBranch: anObject [
	textBranch := anObject
]

{ #category : #accessing }
OpenPonkGitFetchUI >> textRepository [
	^ textRepository
]

{ #category : #accessing }
OpenPonkGitFetchUI >> textRepository: anObject [
	textRepository := anObject
]
