"
A Commander 1 menu group that organizes Git repository operations (GitHub/GitLab commit and fetch) inside the Model menu.
"
Class {
	#name : 'OPGitMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Git-Commands',
	#package : 'OpenPonk-Git',
	#tag : 'Commands'
}

{ #category : 'accessing' }
OPGitMenuGroup >> icon [
	"Answers the Git icon for the repository submenu."
	^ self iconNamed: #git
]

{ #category : 'accessing' }
OPGitMenuGroup >> name [
	"Answers the display name of the Git repository menu group."
	^ 'Git model repository'
]

{ #category : 'accessing' }
OPGitMenuGroup >> order [
	"Answers the order priority of the Git menu group."
	^ 40
]
