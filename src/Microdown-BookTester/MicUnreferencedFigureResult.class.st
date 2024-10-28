"
I represent a figure that refers to a file that does not exist.
"
Class {
	#name : 'MicUnreferencedFigureResult',
	#superclass : 'MicResult',
	#instVars : [
		'figure'
	],
	#category : 'Microdown-BookTester-Results',
	#package : 'Microdown-BookTester',
	#tag : 'Results'
}

{ #category : 'accessing' }
MicUnreferencedFigureResult >> explanation [

	^ 'Figure ', self what,' (in file ', source fullName , ') is not referenced.'
	
]

{ #category : 'accessing' }
MicUnreferencedFigureResult >> figure: aFigureBlock [

	figure := aFigureBlock
]

{ #category : 'accessing' }
MicUnreferencedFigureResult >> what [ 

	^ figure printString
]
