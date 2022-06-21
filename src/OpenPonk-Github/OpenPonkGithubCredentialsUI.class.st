Class {
	#name : #OpenPonkGithubCredentialsUI,
	#superclass : #SpPresenter,
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

{ #category : #'as yet unclassified' }
OpenPonkGithubCredentialsUI class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #labelToken;
				   add: #textToken;
				   yourself)
		  origin: 0 @ 0 corner: 1 @ 0.3;
		  add: (SpBoxLayout newLeftToRight
				   add: #labelSave;
				   add: #checkBoxSave;
				   yourself)
		  origin: 0 @ 0.3 corner: 1 @ 0.6;
		  add: (SpBoxLayout newLeftToRight
				   add: #buttonConfirm;
				   add: #buttonCancel;
				   yourself)
		  origin: 0 @ 0.6 corner: 1 @ 1;
		  yourself
]

{ #category : #specs }
OpenPonkGithubCredentialsUI class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
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

{ #category : #'as yet unclassified' }
OpenPonkGithubCredentialsUI >> connectPresenters [
	buttonConfirm action: [ callOnConfirm value.
		 self window delete ].
	buttonCancel action: [ self window delete ].
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

{ #category : #'as yet unclassified' }
OpenPonkGithubCredentialsUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #initialization }
OpenPonkGithubCredentialsUI >> initializeTextBoxes [

	textToken := self newTextInput
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
