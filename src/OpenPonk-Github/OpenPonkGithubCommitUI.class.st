Class {
	#name : #OpenPonkGithubCommitUI,
	#superclass : #ComposablePresenter,
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
	#category : #'OpenPonk-Github'
}

{ #category : #specs }
OpenPonkGithubCommitUI class >> defaultSpec [
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
			row add: #labelMsg; add: #textMsg ]
		origin: 0 @ 0.6 corner: 1 @ 0.8;
		newRow: [ :row |
			row add: #buttonCommit; add: #buttonCancel ]
		origin: 0 @ 0.8 corner: 1 @ 1;
		yourself.
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> buttonCommit [
	^ buttonCommit
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> buttonCommit: anObject [
	buttonCommit := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> checkBoxSave: anObject [
	checkBoxSave := anObject
]

{ #category : #api }
OpenPonkGithubCommitUI >> extent [
	^ 600@250
]

{ #category : #initialization }
OpenPonkGithubCommitUI >> initializeButtons [
	buttonCommit := self newButton.
	buttonCancel := self newButton.
	buttonCommit 
		label: 'Commit'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGithubCommitUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGithubCommitUI >> initializeFocusOrder [
	self focusOrder 
		add: textRepository;
		add: textBranch;
		add: checkBoxSave;
		add: textMsg;
		add: buttonCommit;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGithubCommitUI >> initializeLabels [
	labelBranch := self newLabel.	
	labelSave  := self newLabel.	
	labelRepository  := self newLabel.	
	labelMsg := self newLabel.	
	
	labelBranch label: 'Branch name'.
	labelSave label: 'Save repository and branch?'.
	labelRepository label: 'Repository name'.
	labelMsg  label: 'Commit message'.
	
]

{ #category : #initialization }
OpenPonkGithubCommitUI >> initializePresenter [
	buttonCommit action: [ self model commitSet: self.
		 self window delete. ].
	buttonCancel action: [ self window delete ].
]

{ #category : #initialization }
OpenPonkGithubCommitUI >> initializeTextBoxes [
	textBranch := self newTextInput.
	textBranch autoAccept: true.
	textRepository  := self newTextInput.
	textRepository autoAccept: true.
	textRepository ghostText: 'owner/repository'.
	textMsg := self newTextInput.	
	textMsg autoAccept: true.
]

{ #category : #initialization }
OpenPonkGithubCommitUI >> initializeWidgets [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelBranch [
	^ labelBranch
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelBranch: anObject [
	labelBranch := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelMsg [
	^ labelMsg
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelMsg: anObject [
	labelMsg := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelRepository [
	^ labelRepository
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelRepository: anObject [
	labelRepository := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> model [
	^ model
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> model: anObject [
	model := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> textBranch [
	^ textBranch
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> textBranch: anObject [
	textBranch := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> textMsg [
	^ textMsg
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> textMsg: anObject [
	textMsg := anObject
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> textRepository [
	^ textRepository
]

{ #category : #accessing }
OpenPonkGithubCommitUI >> textRepository: anObject [
	textRepository := anObject
]

{ #category : #api }
OpenPonkGithubCommitUI >> title [
	^ 'Commit form'.
]
