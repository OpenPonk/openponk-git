"
I am a Spec presenter that extends OpenPonkGitRepositoryUI to provide a user interface for committing project changes to a remote Git repository. I introduce a field for capturing the commit message.
"
Class {
	#name : 'OPGitCommitUI',
	#superclass : 'OPGitRepositoryUI',
	#instVars : [
		'labelMsg',
		'textMsg'
	],
	#category : 'OpenPonk-Git-GUI',
	#package : 'OpenPonk-Git',
	#tag : 'GUI'
}

{ #category : 'layout' }
OPGitCommitUI class >> addItemsTo: aLayout [

	super addItemsTo: aLayout.
	aLayout add: (SpBoxLayout newLeftToRight
			 spacing: 5;
			 add: #labelMsg width: self labelsWidth;
			 add: #textMsg;
			 yourself)
]

{ #category : 'updating' }
OPGitCommitUI >> checkAllFilled [

	super checkAllFilled.
	buttonConfirm isEnabled ifFalse: [ ^ self ].
	textMsg text trim ifEmpty: [ ^ buttonConfirm disable ].
	buttonConfirm enable
]

{ #category : 'initialization' }
OPGitCommitUI >> connectPresenters [

	super connectPresenters.
	
	textMsg whenTextChangedDo: [ self checkAllFilled ]
]

{ #category : 'initialization' }
OPGitCommitUI >> initializeButtons [

	super initializeButtons.
	buttonConfirm label: 'Commit'
]

{ #category : 'initialization' }
OPGitCommitUI >> initializeFocusOrder [

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
OPGitCommitUI >> initializeLabels [

	super initializeLabels.
	labelMsg := self newLabel.
	labelMsg label: 'Commit message'
]

{ #category : 'initialization' }
OPGitCommitUI >> initializeTextBoxes [

	super initializeTextBoxes.
	textMsg := self newTextInput
]

{ #category : 'initialization' }
OPGitCommitUI >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow
		initialExtent: 480 @ 230;
		title: 'Git commit'
]

{ #category : 'accessing' }
OPGitCommitUI >> textMsg [
	^ textMsg
]
