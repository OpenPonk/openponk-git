Class {
	#name : #BaselineOfOpenPonkGithub,
	#superclass : #BaselineOf,
	#category : #BaselineOfOpenPonkGithub
}

{ #category : #baselines }
BaselineOfOpenPonkGithub >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'OpenPonk-Github'.
			spec group: 'default' with: #('OpenPonk-Github') ]
]
