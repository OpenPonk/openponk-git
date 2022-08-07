Class {
	#name : #OpenPonkGitAuthorUI,
	#superclass : #SpPresenter,
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
	#category : #'OpenPonk-Git'
}

{ #category : #'as yet unclassified' }
OpenPonkGitAuthorUI class >> defaultLayout [

	| labelsWidth |
	labelsWidth := 150.
	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #labelName width: labelsWidth;
				   add: #textName;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #labelEmail width: labelsWidth;
				   add: #textEmail;
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
				   add: #buttonConfirm expand: false;
				   yourself);
		  yourself
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> buttonCancel [
	^ buttonCancel
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> buttonCancel: anObject [
	buttonCancel := anObject
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> buttonConfirm [
	^ buttonConfirm
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> buttonConfirm: anObject [
	buttonConfirm := anObject
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> checkBoxSave [
	^ checkBoxSave
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> checkBoxSave: anObject [
	checkBoxSave := anObject
]

{ #category : #'as yet unclassified' }
OpenPonkGitAuthorUI >> connectPresenters [
	buttonConfirm action: [ self model authorSet: self.
		 self window delete. ].
	buttonCancel action: [ self window delete ].
]

{ #category : #initialization }
OpenPonkGitAuthorUI >> initializeButtons [
	buttonConfirm := self newButton.
	buttonCancel := self newButton.
	buttonConfirm 
		label: 'Confirm'.
	buttonCancel
		label: 'Cancel'.
]

{ #category : #initialization }
OpenPonkGitAuthorUI >> initializeCheckBoxes [
	checkBoxSave := self newCheckBox.
	checkBoxSave state: false.
]

{ #category : #initialization }
OpenPonkGitAuthorUI >> initializeFocusOrder [
	self focusOrder 
		add: textName;
		add: textEmail;
		add: checkBoxSave;
		add: buttonConfirm;
		add: buttonCancel.
		
]

{ #category : #initialization }
OpenPonkGitAuthorUI >> initializeLabels [
	labelName := self newLabel.	
	labelSave  := self newLabel.	
	labelEmail  := self newLabel.	
	
	labelName label: 'Authors name'.
	labelSave label: 'Save for future use?'.
	labelEmail label: 'Authors email'.
	
]

{ #category : #'as yet unclassified' }
OpenPonkGitAuthorUI >> initializePresenters [
	self 
		initializeLabels;
		initializeButtons;
		initializeTextBoxes;
		initializeCheckBoxes;
		initializeFocusOrder.
]

{ #category : #initialization }
OpenPonkGitAuthorUI >> initializeTextBoxes [

	textName := self newTextInput.
	textEmail := self newTextInput
]

{ #category : #api }
OpenPonkGitAuthorUI >> initializeWindow: aWindow [

	aWindow
		initialExtent: 400 @ 155;
		title: 'Author form'
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> labelEmail [
	^ labelEmail
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> labelEmail: anObject [
	labelEmail := anObject
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> labelName [
	^ labelName
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> labelName: anObject [
	labelName := anObject
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> labelSave [
	^ labelSave
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> labelSave: anObject [
	labelSave := anObject
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> model [
	^ model
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> model: anObject [
	model := anObject
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> textEmail [
	^ textEmail
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> textEmail: anObject [
	textEmail := anObject
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> textName [
	^ textName
]

{ #category : #accessing }
OpenPonkGitAuthorUI >> textName: anObject [
	textName := anObject
]
