Class {
	#name : 'OpenPonkGitCommitUI',
	#superclass : 'OpenPonkGitRepositoryUI',
	#instVars : [
		'labelMsg',
		'textMsg'
	],
	#category : 'OpenPonk-Git',
	#package : 'OpenPonk-Git'
}

{ #category : 'layout' }
OpenPonkGitCommitUI class >> addItemsTo: aLayout [

	super addItemsTo: aLayout.
	aLayout add: (SpBoxLayout newLeftToRight
			 spacing: 5;
			 add: #labelMsg width: self labelsWidth;
			 add: #textMsg;
			 yourself)
]

{ #category : 'as yet unclassified' }
OpenPonkGitCommitUI >> checkAllFilled [

	super checkAllFilled.
	buttonConfirm isEnabled ifFalse: [ ^ self ].
	textMsg text trim ifEmpty: [ ^ buttonConfirm disable ].
	buttonConfirm enable
]

{ #category : 'initialization' }
OpenPonkGitCommitUI >> connectPresenters [

	super connectPresenters.
	
	textMsg whenTextChangedDo: [ self checkAllFilled ]
]

{ #category : 'initialization' }
OpenPonkGitCommitUI >> initializeButtons [

	super initializeButtons.
	buttonConfirm label: 'Commit'
]

{ #category : 'initialization' }
OpenPonkGitCommitUI >> initializeFocusOrder [

	self focusOrder
		add: textToken;
		add: textRepository;
		add: textBranch;
		add: checkBoxSave;
		add: textMsg;
		add: buttonConfirm;
		add: buttonCancel
]

{ #category : 'initialization' }
OpenPonkGitCommitUI >> initializeLabels [

	super initializeLabels.
	labelMsg := self newLabel.
	labelMsg label: 'Commit message'
]

{ #category : 'initialization' }
OpenPonkGitCommitUI >> initializeTextBoxes [

	super initializeTextBoxes.
	textMsg := self newTextInput
]

{ #category : 'initialization' }
OpenPonkGitCommitUI >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow
		initialExtent: 480 @ 230;
		title: 'Git commit'
]

{ #category : 'accessing' }
OpenPonkGitCommitUI >> textMsg [
	^ textMsg
]
