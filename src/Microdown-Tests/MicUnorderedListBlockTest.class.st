"
I'm a test class for testing the behavior of MicUnorderedListBlock
"
Class {
	#name : #MicUnorderedListBlockTest,
	#superclass : #MicBlockTest,
	#category : #'Microdown-Tests-Parser'
}

{ #category : #tests }
MicUnorderedListBlockTest >> subjectClass [ 
	^ MicUnorderedListBlock  
]

{ #category : #tests }
MicUnorderedListBlockTest >> testEmbeddedOrdered [
	| source root list |
	source := 
'- item 1
  1. sublevel item 1
  4. sublevel item 2
- item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 2.
	self assert: list children second text equals: 'item 2'.
	self assert: list children first "item 1"
			children second "unordered list"
			children second "sub item"
			text equals: 'sublevel item 2'
]

{ #category : #tests }
MicUnorderedListBlockTest >> testEmbeddedOrderedWithFormatting [
	| source root list item4 |
	source := 
'- item 1
  1. **sublevel** ~item 1~
  4. **sublevel4** ~item 24~
- item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 2.
	
	item4 := list children first "item 1"
			children second "unordered list"
			children second.
			
	self assert: item4 text equals: 'sublevel4 item 24'.
	self assert: item4 textElements first kind equals: 'bold'.
	self assert: item4 textElements first substring equals: 'sublevel4'.

	self assert: item4 textElements third kind equals: 'strike'.
	self assert: item4 textElements third substring equals: 'item 24'.
]

{ #category : #tests }
MicUnorderedListBlockTest >> testMixing2 [
	| source root list1 list2 |
	source := 
'
- item 1
  - sub item 1.1
  - sub item 1.2
- item 2

1. item1
   - sub item 1
   - sub item 2
3. item 2
'.
	root := parser parse: source.
	self assert: root children size equals: 2. 
	list1 := root children first.
	self assert: list1 children size equals: 2.
	self assert: list1 children second text equals: 'item 2'.
	
	list2 := root children second.
	self assert: list2 children size equals: 2.
	self assert: list2 children second text equals: 'item 2'.
]

{ #category : #tests }
MicUnorderedListBlockTest >> testMixingOrderedInsideUnorderedWithParagraph [
	| source root list1  |
	source := 
'
- item 1
  on 
  multiple lines
   1. sub item 1 
   3. sub item 2
- item 2
'.
	root := parser parse: source.
	self assert: root children size equals: 1. 
	list1 := root children first.
	self assert: list1 children size equals: 2.
	self assert: list1 children second text equals: 'item 2'.
	
	self assert: list1 children first text equals: 'item 1
on 
multiple lines
 1. sub item 1 
 3. sub item 2'.
]

{ #category : #'tests - nested' }
MicUnorderedListBlockTest >> testNestedLevel [
	| source root list item1|
	source := 
'- item 1
  1. sublevel
- item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 2.
	
	item1 := list children first.
	self assert: item1 text equals: 'item 1'.
	self assert: item1 class equals: MicListItemBlock.
	self assert: item1 nestedLevel equals: 1.
	
	"this is the inner list"
	self assert: item1 children second nestedLevel equals: 2.
	self assert: item1 children second class equals: MicOrderedListBlock.
		
	"this is the inner list first item"
	self assert: item1 children second children first text equals: 'sublevel'.
	self assert: item1 children second children first class equals: MicListItemBlock.

	

]

{ #category : #'tests - nested' }
MicUnorderedListBlockTest >> testNestedLevel2 [
	| source root list item1 sublevelItem|
	source := 
'- item 1
  - sublevel
    - subsublevel
  - sublevel2
- item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 2.
	
	item1 := list children first.
	sublevelItem := item1 children second children first.
	
	"this is the inner list"
	self assert: item1 children second nestedLevel equals: 2.
	self assert: item1 children second class equals: MicUnorderedListBlock.
		
	"this is the inner list first item"
	self assert: sublevelItem text equals: 'sublevel'.
	self assert: sublevelItem class equals: MicListItemBlock.

	self assert: sublevelItem children second children first nestedLevel equals: 3.
	self assert: sublevelItem children second children first text equals: 'subsublevel'.
]

{ #category : #'tests - list' }
MicUnorderedListBlockTest >> testOrderedListAPIToAccessText [

	| list |
	list := (self parser parse: '1.a 2.b') children first children first.
	self assert: list class equals: MicListItemBlock.
	self assert: list nestedLevel equals: 1.
	self assert: list text equals: '2.b'
]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelList [
	| source root list |
	source := 
'- item 1
- item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 2.
	self assert: list children second text equals: 'item 2'
]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelList2 [
	| source root list |
	source := 
'- item 1
  expanded
- item 2'.
	root := parser parse: source.
	self assert: root children size equals: 1.
	"root contains only a list."
	list := root children first.
	self assert: list children size equals: 2.
	self assert: list children first text equals: 'item 1
expanded'
]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelList2WithFormatting [
	| source root list |
	source := 
'- **item 1**
  `expanded`
- item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children first text equals: 'item 1
expanded'.
	self assert: list children first textElements size equals: 3.
	self assert: list children first textElements first kind equals: 'bold'.
	self assert: list children first textElements first substring equals: 'item 1'.
	self assert: list children first textElements third kind equals: 'monospace'.
	self assert: list children first textElements third substring equals: 'expanded'.
]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelListAllBulletTypes [
	| source root list |
	source := 
'& item 1
& item 2'.
	'+-*' do: [ :bullet |
	root := parser parse: (source copyReplaceAll: '&' with: bullet asString).
	list := root children first.
	self assert: list children size equals: 2.]
]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelListSplitWithEmptyLine [
	| source root list |
	source := 
'- item 1
- item 2

- item 3 of the same list'.
	root := parser parse: source.
	self assert: root children size equals: 1.
	"root contains a list"
	
	list := root children first.
	self assert: list children size equals: 3.
	self assert: list children first text equals: 'item 1'.
	self assert: list children third text equals: 'item 3 of the same list'.


]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelListSplitWithMultipleEmptyLines [
	| source root list |
	source := 
'- item 1
- item 2




- item 3 of the same list'.
	root := parser parse: source.
	self assert: root children size equals: 1.
	"root contains a list"
	
	list := root children first.
	self assert: list children size equals: 3.
	self assert: list children first text equals: 'item 1'.
	self assert: list children third text equals: 'item 3 of the same list'.


]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelListStartingWithoutSpaceSplitParagraph [
	| source root list |
	source := 
'- item 1
  expanded
and here
- item 2'.
	root := parser parse: source.
	self assert: root children size equals: 3.
	"root contains a list, a paragraph and another list"
	
	list := root children first.
	self assert: list children size equals: 1.
	self assert: list children first text equals: 'item 1
expanded'.
	self assert: root children third children first text equals: 'item 2'.


]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelListStartingWithoutSpaceSplitParagraph2 [
	| source root list |
	source := 
'- item 1
  expanded
  same indentation no new paragraph
- item 2'.
	root := parser parse: source.
	self assert: root children size equals: 1.
	"root contains a list"
	
	list := root children first.
	self assert: list children size equals: 2.
	self assert: list children first text equals: 'item 1
expanded
same indentation no new paragraph'.
	self assert: list children second text equals: 'item 2'.


]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelListWithItemSpawning [
	| root list |
	root :=  parser
		parse:
'- first item
  with a follow up 
  and another one. 
- second item
  follow up of second item'.
	list := root children first.
	self assert: list children size equals: 2.
	self assert: list children second text equals: 'second item
follow up of second item'.
	
]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelListWithStar [
	| source root list |
	source := 
'* item 1
* item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 2.
	self assert: list children second text equals: 'item 2'
]

{ #category : #tests }
MicUnorderedListBlockTest >> testSingleLevelMixedList [
	| source root list |
	source := 
'- item 1
* item 2
- item 3'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 3.
	self assert: list children second text equals: 'item 2'
]

{ #category : #tests }
MicUnorderedListBlockTest >> testTwoLevelList [
	| source root list |
	source := 
'- item 1
  * sublevel1
  * sublevel2
  * sublevel3
- item 2'.
	root := parser parse: source.
	list := root children first.
	self assert: list children size equals: 2.
	self assert: list children second text equals: 'item 2'.
	self assert: list children first "item 1 list"
			children second "unorded list"
			children first "sub item"
			text equals: 'sublevel1'.
	self assert: list children first "item 1"
			children second "unorded list"
			children second "sub item"
			text equals: 'sublevel2'
			
]
