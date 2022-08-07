Class {
	#name : #OpenPonkGitCredentialsUI,
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
	#category : #'OpenPonk-Git'
}

{ #category : #'as yet unclassified' }
OpenPonkGitCredentialsUI class >> defaultLayout [

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
OpenPonkGitCredentialsUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> buttonConfirm [
	^ buttonConfirm
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> buttonConfirm: anObject [
	buttonConfirm := anObject
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> callOnConfirm [
	^ callOnConfirm
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> callOnConfirm: anObject [
	callOnConfirm := anObject
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> checkBoxSave [
	^ checkBoxSave.
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> checkBoxSave: anObject [
	checkBoxSave := anObject.
]

{ #category : #'as yet unclassified' }
OpenPonkGitCredentialsUI >> connectPresenters [
	buttonConfirm action: [ callOnConfirm value.
		 self window delete ].
	buttonCancel action: [ self window delete ].
]

{ #category : #initialization }
OpenPonkGitCredentialsUI >> initializeButtons [
	buttonConfirm := self newButton.
	buttonCancel := self newButton.
	buttonConfirm 
		label: 'Confirm'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGitCredentialsUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGitCredentialsUI >> initializeFocusOrder [
	self focusOrder 
		add: textToken;
		add: checkBoxSave;
		add: buttonConfirm;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGitCredentialsUI >> initializeLabels [	
	labelSave  := self newLabel.	
	labelToken := self newLabel.	
	
	labelSave label: 'Save credentials?'.
	labelToken  label: 'Personal access token'.
]

{ #category : #'as yet unclassified' }
OpenPonkGitCredentialsUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #initialization }
OpenPonkGitCredentialsUI >> initializeTextBoxes [

	textToken := self newTextInput
]

{ #category : #api }
OpenPonkGitCredentialsUI >> initializeWindow: aWindow [

	aWindow
		initialExtent: 450 @ 130;
		title: 'Credentials form'
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> labelToken [
	^ labelToken
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> labelToken: anObject [
	labelToken := anObject
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> textToken [
	^ textToken
]

{ #category : #accessing }
OpenPonkGitCredentialsUI >> textToken: anObject [
	textToken := anObject
]
