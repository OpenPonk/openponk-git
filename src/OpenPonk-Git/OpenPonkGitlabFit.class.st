Class {
	#name : #OpenPonkGitlabFit,
	#superclass : #OpenPonkGitlab,
	#category : #'OpenPonk-Git'
}

{ #category : #'as yet unclassified' }
OpenPonkGitlabFit >> apiName [

	^ 'FIT GitLab'
]

{ #category : #'constants - url' }
OpenPonkGitlabFit >> apiURL [
	^ 'https://gitlab.fit.cvut.cz/api/v4'
]
