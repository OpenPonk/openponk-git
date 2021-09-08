Class {
	#name : #OpenPonkGithubFetchUI,
	#superclass : #ComposablePresenter,
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

{ #category : #specs }
OpenPonkGithubFetchUI class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row |
			row add: #labelRepository; add: #textRepository ]
		origin: 0 @ 0 corner: 1 @ 0.2;
		newRow: [ :row |
			row add: #labelBranch; add: #textBranch  ]
		origin: 0 @ 0.2 corner: 1 @ 0.4;
		newRow: [ :row |
			row add: #labelSave; add: #checkBoxSave ]
		origin: 0 @ 0.4 corner: 1 @ 0.6;
		newRow: [ :row |
			row add: #buttonFetch; add: #buttonCancel ]
		origin: 0 @ 0.8 corner: 1 @ 1;
		yourself.
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

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializePresenter [
	buttonFetch action: [ self model fetchRepositoryFilled: self.
		 self window delete. ].
	buttonCancel action: [ self window delete ].
]

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializeTextBoxes [
	textBranch := self newTextInput.
	textBranch autoAccept: true.
	textRepository  := self newTextInput.
	textRepository autoAccept: true.
	textRepository ghostText: 'owner/repository'.
]

{ #category : #initialization }
OpenPonkGithubFetchUI >> initializeWidgets [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
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
