"
I am a Spec presenter that extends OpenPonkGitRepositoryUI to provide a user interface for fetching and importing an OpenPonk project from a remote Git repository.
"
Class {
	#name : 'OPGitFetchUI',
	#superclass : 'OPGitRepositoryUI',
	#category : 'OpenPonk-Git-GUI',
	#package : 'OpenPonk-Git',
	#tag : 'GUI'
}

{ #category : 'initialization' }
OPGitFetchUI >> initializeButtons [

	super initializeButtons.
	buttonConfirm label: 'Fetch'
]

{ #category : 'initialization' }
OPGitFetchUI >> initializeFocusOrder [

	self focusOrder
		add: textToken;
		add: textRepository;
		add: textBranch;
		add: checkBoxSave;
		add: buttonConfirm;
		add: buttonCancel
]

{ #category : 'initialization' }
OPGitFetchUI >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow
		initialExtent: 450 @ 200;
		title: 'Git fetch'
]
