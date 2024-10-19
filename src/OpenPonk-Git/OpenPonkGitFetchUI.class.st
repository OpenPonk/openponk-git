Class {
	#name : 'OpenPonkGitFetchUI',
	#superclass : 'OpenPonkGitRepositoryUI',
	#category : 'OpenPonk-Git',
	#package : 'OpenPonk-Git'
}

{ #category : 'initialization' }
OpenPonkGitFetchUI >> initializeButtons [

	super initializeButtons.
	buttonConfirm label: 'Fetch'
]

{ #category : 'initialization' }
OpenPonkGitFetchUI >> initializeFocusOrder [

	self focusOrder
		add: textToken;
		add: textRepository;
		add: textBranch;
		add: checkBoxSave;
		add: buttonConfirm;
		add: buttonCancel
]

{ #category : 'initialization' }
OpenPonkGitFetchUI >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow
		initialExtent: 450 @ 200;
		title: 'Git fetch'
]
