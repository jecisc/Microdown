Extension { #name : #MicrodownVisitor }

{ #category : #'*Microdown-RichTextComposer' }
MicrodownVisitor >> visitCenter: aMicCenterBlock [
	self visitEnvironment:  aMicCenterBlock
]

{ #category : #'*Microdown-RichTextComposer' }
MicrodownVisitor >> visitRichTextFormatConfiguration: config [
	self visitAnnotation: config
]

{ #category : #'*Microdown-RichTextComposer' }
MicrodownVisitor >> visitRightAlignment: aMicRightAlignmentBlock [ 
	self visitEnvironment:  aMicRightAlignmentBlock
]
