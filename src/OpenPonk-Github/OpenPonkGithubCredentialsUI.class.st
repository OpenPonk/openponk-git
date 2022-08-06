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
				   spacing: 5;
				   add: #labelToken width: 140;
				   add: #textToken;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #labelSave width: 140;
				   add: #checkBoxSave;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   hAlignEnd;
				   add: #buttonCancel expand: false;
				   add: #buttonConfirm expand: false;
				   yourself);
		  yourself
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
	labelToken  label: 'Personal access token'.
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

{ #category : #api }
OpenPonkGithubCredentialsUI >> initializeWindow: aWindow [

	aWindow
		initialExtent: 450 @ 130;
		title: 'Credentials form'
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
