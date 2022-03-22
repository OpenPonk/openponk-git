Class {
	#name : #OpenPonkGithubCredentialsUI,
	#superclass : #ComposablePresenter,
	#instVars : [
		'callOnConfirm',
		'labelToken',
		'labelSave',
		'buttonConfirm',
		'buttonCancel',
		'checkBoxSave',
		'textToken'
	],
	#category : #'OpenPonk-Github'
}

{ #category : #specs }
OpenPonkGithubCredentialsUI class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row |
			row add: #labelToken; add: #textToken ]
		origin: 0 @ 0 corner: 1 @ 0.3;
		newRow: [ :row |
			row add: #labelSave; add: #checkBoxSave ]
		origin: 0 @ 0.3 corner: 1 @ 0.6;
		newRow: [ :row |
			row add: #buttonConfirm; add: #buttonCancel ]
		origin: 0 @ 0.6 corner: 1 @ 1;
		yourself.
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> buttonConfirm [
	^ buttonConfirm
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> buttonConfirm: anObject [
	buttonConfirm := anObject
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> callOnConfirm [
	^ callOnConfirm
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> callOnConfirm: anObject [
	callOnConfirm := anObject
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> checkBoxSave [
	^ checkBoxSave.
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> checkBoxSave: anObject [
	checkBoxSave := anObject.
]

{ #category : #api }
OpenPonkGithubCredentialsUI >> extent [
	^ 600@130
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializeButtons [
	buttonConfirm := self newButton.
	buttonCancel := self newButton.
	buttonConfirm 
		label: 'Confirm'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializeFocusOrder [
	self focusOrder 
		add: textToken;
		add: checkBoxSave;
		add: buttonConfirm;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializeLabels [	
	labelSave  := self newLabel.	
	labelToken := self newLabel.	
	
	labelSave label: 'Save credentials?'.
	labelToken  label: 'Personal token'.
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializePresenter [
	buttonConfirm action: [ callOnConfirm value.
		 self window delete ].
	buttonCancel action: [ self window delete ].
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializeTextBoxes [
	textToken := self newTextInput.
	textToken autoAccept: true.
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializeWidgets [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> labelToken [
	^ labelToken
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> labelToken: anObject [
	labelToken := anObject
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> textToken [
	^ textToken
]

{ #category : #accessing }
OpenPonkGithubCredentialsUI >> textToken: anObject [
	textToken := anObject
]

{ #category : #api }
OpenPonkGithubCredentialsUI >> title [
	^ 'Credentials form'.
]
