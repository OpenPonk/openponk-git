"
Unit tests for Git commit and fetch Spec presenters and input validation.
"
Class {
	#name : 'OPGitRepositoryUITest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Git-Tests-UI',
	#package : 'OpenPonk-Git-Tests',
	#tag : 'UI'
}

{ #category : 'tests' }
OPGitRepositoryUITest >> testCommitAndFetchUIValidationAndConfirmCallback [
	| commitUI fetchUI commitWindow fetchWindow commitConfirmButton fetchConfirmButton confirmed |
	confirmed := false.
	commitUI := OPGitCommitUI newApplication: SpApplication defaultApplication.
	commitUI onConfirmDo: [ confirmed := true ].
	commitWindow := commitUI asWindow.
	[
		commitConfirmButton := commitUI instVarNamed: #buttonConfirm.

		self deny: commitUI checkBoxSave state description: 'Save checkbox must default to unchecked'.
		self deny: commitConfirmButton isEnabled description: 'Confirm button must be disabled when fields are empty'.
		commitUI textToken text: 'tok'.
		commitUI textRepository text: 'org/repo'.
		commitUI textBranch text: 'main'.
		commitUI checkAllFilled.
		self deny: commitConfirmButton isEnabled description: 'Commit button must stay disabled when commit message is empty'.

		commitUI textMsg text: 'feat: update'.
		commitUI checkAllFilled.
		self assert: commitConfirmButton isEnabled description: 'Commit button must be enabled when all fields are filled'.
		commitConfirmButton performAction.
		self assert: confirmed description: 'Confirm callback must execute on button click'
	] ensure: [ commitWindow close ].

	fetchUI := OPGitFetchUI newApplication: SpApplication defaultApplication.
	fetchWindow := fetchUI asWindow.
	[
		fetchConfirmButton := fetchUI instVarNamed: #buttonConfirm.
		self deny: fetchConfirmButton isEnabled description: 'Fetch button must be disabled when fields are empty'.
		fetchUI textToken text: 'tok'.
		fetchUI textRepository text: 'org/repo'.
		fetchUI textBranch text: 'main'.
		fetchUI checkAllFilled.
		self assert: fetchConfirmButton isEnabled description: 'Fetch button must be enabled when all fields are filled'.
		self assert: fetchUI textBranch text equals: 'main'
	] ensure: [ fetchWindow close ]
]
