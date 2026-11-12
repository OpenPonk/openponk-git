"
Metacello baseline for the OpenPonk Git integration plugin, defining its package dependencies and load configurations.
"
Class {
	#name : 'BaselineOfOpenPonkGit',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenPonkGit',
	#package : 'BaselineOfOpenPonkGit'
}

{ #category : 'baselines' }
BaselineOfOpenPonkGit >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			baseline: 'OpenPonk'
			with: [ spec repository: 'github://OpenPonk/openponk' ].
		spec
			package: 'OpenPonk-Git'
			with: [ spec requires: #( 'OpenPonk' ) ].
		spec
			package: 'OpenPonk-Git-Tests'
			with: [ spec requires: #( 'OpenPonk-Git' ) ].
		spec
			group: 'default' with: #( 'OpenPonk-Git' 'OpenPonk-Git-Tests' ) ]
]
