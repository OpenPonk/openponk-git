Class {
	#name : #OpenPonkGithubAuthorUI,
	#superclass : #ComposablePresenter,
	#instVars : [
		'model',
		'labelName',
		'labelEmail',
		'labelSave',
		'textName',
		'textEmail',
		'buttonConfirm',
		'buttonCancel',
		'checkBoxSave'
	],
	#category : #'OpenPonk-Github'
}

{ #category : #specs }
OpenPonkGithubAuthorUI class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row |
			row add: #labelName; add: #textName ]
		origin: 0 @ 0 corner: 1 @ 0.2;
		newRow: [ :row |
			row add: #labelEmail; add: #textEmail ]
		origin: 0 @ 0.2 corner: 1 @ 0.4;
		newRow: [ :row |
			row add: #labelSave; add: #checkBoxSave ]
		origin: 0 @ 0.4 corner: 1 @ 0.6;
		newRow: [ :row |
			row add: #buttonConfirm; add: #buttonCancel ]
		origin: 0 @ 0.8 corner: 1 @ 1;
		yourself.
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> buttonConfirm [
	^ buttonConfirm
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> buttonConfirm: anObject [
	buttonConfirm := anObject
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> checkBoxSave: anObject [
	checkBoxSave := anObject
]

{ #category : #api }
OpenPonkGithubAuthorUI >> extent [
	^ 600@200
]

{ #category : #initialization }
OpenPonkGithubAuthorUI >> initializeButtons [
	buttonConfirm := self newButton.
	buttonCancel := self newButton.
	buttonConfirm 
		label: 'Confirm'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGithubAuthorUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGithubAuthorUI >> initializeFocusOrder [
	self focusOrder 
		add: textName;
		add: textEmail;
		add: checkBoxSave;
		add: buttonConfirm;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGithubAuthorUI >> initializeLabels [
	labelName := self newLabel.	
	labelSave  := self newLabel.	
	labelEmail  := self newLabel.	
	
	labelName label: 'Authors name'.
	labelSave label: 'Save for future use?'.
	labelEmail label: 'Authors email'.
	
]

{ #category : #initialization }
OpenPonkGithubAuthorUI >> initializePresenter [
	buttonConfirm action: [ self model authorSet: self.
		 self window delete. ].
	buttonCancel action: [ self window delete ].
]

{ #category : #initialization }
OpenPonkGithubAuthorUI >> initializeTextBoxes [
	textName := self newTextInput.
	textName autoAccept: true.
	textEmail := self newTextInput.
	textEmail autoAccept: true.
]

{ #category : #initialization }
OpenPonkGithubAuthorUI >> initializeWidgets [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> labelEmail [
	^ labelEmail
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> labelEmail: anObject [
	labelEmail := anObject
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> labelName [
	^ labelName
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> labelName: anObject [
	labelName := anObject
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> model [
	^ model
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> model: anObject [
	model := anObject
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> textEmail [
	^ textEmail
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> textEmail: anObject [
	textEmail := anObject
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> textName [
	^ textName
]

{ #category : #accessing }
OpenPonkGithubAuthorUI >> textName: anObject [
	textName := anObject
]

{ #category : #api }
OpenPonkGithubAuthorUI >> title [
	^ 'Author form'.
]
