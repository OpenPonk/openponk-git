Class {
	#name : #OpenPonkGithubFetchUI,
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
	#category : #'OpenPonk-Github'
}

{ #category : #'as yet unclassified' }
OpenPonkGithubFetchUI class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #labelRepository;
				   add: #textRepository;
				   yourself)
		  origin: 0 @ 0 corner: 1 @ 0.2;
		  add: (SpBoxLayout newLeftToRight
				   add: #labelBranch;
				   add: #textBranch;
				   yourself)
		  origin: 0 @ 0.2 corner: 1 @ 0.4;
		  add: (SpBoxLayout newLeftToRight
				   add: #labelSave;
				   add: #checkBoxSave;
				   yourself)
		  origin: 0 @ 0.4 corner: 1 @ 0.6;
		  add: (SpBoxLayout newLeftToRight
				   add: #buttonFetch;
				   add: #buttonCancel;
				   yourself)
		  origin: 0 @ 0.8 corner: 1 @ 1;
		  yourself
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> buttonFetch [
	^ buttonFetch
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> buttonFetch: anObject [
	buttonFetch := anObject
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> checkBoxSave: anObject [
	checkBoxSave := anObject
]

{ #category : #'as yet unclassified' }
OpenPonkGithubFetchUI >> connectPresenters [
	buttonFetch action: [ self model fetchRepositoryFilled: self.
		 self window delete. ].
	buttonCancel action: [ self window delete ].
]

{ #category : #api }
OpenPonkGithubFetchUI >> extent [
	^ 600@250
]

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializeButtons [
	buttonFetch := self newButton.
	buttonCancel := self newButton.
	buttonFetch 
		label: 'Fetch'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializeFocusOrder [
	self focusOrder 
		add: textRepository;
		add: textBranch;
		add: checkBoxSave;
		add: buttonFetch;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializeLabels [
	labelBranch := self newLabel.	
	labelSave  := self newLabel.	
	labelRepository  := self newLabel.	
	
	labelBranch label: 'Branch name'.
	labelSave label: 'Save repository and branch?'.
	labelRepository label: 'Repository name'.
]

{ #category : #'as yet unclassified' }
OpenPonkGithubFetchUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializeTextBoxes [

	textBranch := self newTextInput.
	textRepository := self newTextInput.
	textRepository placeholder: 'owner/repository'
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> labelBranch [
	^ labelBranch
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> labelBranch: anObject [
	labelBranch := anObject
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> labelRepository [
	^ labelRepository
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> labelRepository: anObject [
	labelRepository := anObject
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> model [
	^ model
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> model: anObject [
	model := anObject
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> textBranch [
	^ textBranch
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> textBranch: anObject [
	textBranch := anObject
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> textRepository [
	^ textRepository
]

{ #category : #accessing }
OpenPonkGithubFetchUI >> textRepository: anObject [
	textRepository := anObject
]

{ #category : #api }
OpenPonkGithubFetchUI >> title [
	^ 'Repository form'.
]
