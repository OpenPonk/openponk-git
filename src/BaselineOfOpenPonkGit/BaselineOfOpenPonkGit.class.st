Class {
	#name : 'BaselineOfOpenPonkGit',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenPonkGit',
	#package : 'BaselineOfOpenPonkGit'
}

{ #category : 'baselines' }
BaselineOfOpenPonkGit >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'OpenPonk-Git'.
			spec group: 'default' with: #('OpenPonk-Git') ]
]
