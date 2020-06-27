Class {
	#name : #ReadStream,
	#superclass : #Object,
	#instVars : [
		'collection',
		'position',
		'readLimit'
	],
	#category : #'Collections-Streams'
}

{ #category : #all }
ReadStream class >> on: aCollection [
	"Answer an instance of me, streaming over the elements of aCollection."

	^ self basicNew on: aCollection
]

{ #category : #all }
ReadStream >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ position >= readLimit
]

{ #category : #all }
ReadStream >> contents [
	"Answer with a copy of my collection from 1 to readLimit."

	^ collection copyFrom: 1 to: readLimit
]

{ #category : #all }
ReadStream >> next [
	"Answer the next object in the Stream represented by the receiver."

	position >= readLimit
		ifTrue: [ ^ nil ]
		ifFalse: [ ^ collection at: (position := position + 1) ]
]

{ #category : #all }
ReadStream >> next: anInteger [
	"Answer a collection containing the next anInteger elements of my collection."

	| end result |
	end := position + anInteger min: readLimit.
	result := collection copyFrom: position + 1 to: end.
	position := end.
	^ result
]

{ #category : #all }
ReadStream >> on: aCollection [
	"Initialize myself for streaming over the given collection."

	collection := aCollection.
	readLimit := aCollection size.
	position := 0
]

{ #category : #all }
ReadStream >> peek [
	"Answer the next object without advancing my position. Answer nil if there are no more elements."

	| result |
	self atEnd
		ifTrue: [ ^ nil ].
	result := self next.
	position := position - 1.
	^ result
]

{ #category : #all }
ReadStream >> peekFor: anObject [
	"If my next element equals the given object, skip it and answer true. Otherwise, answer false and leave my position unchanged."

	| result |
	result := self peek = anObject.
	result
		ifTrue: [ self skip: 1 ].
	^ result
]

{ #category : #all }
ReadStream >> position [
	"Answer the current position of accessing the sequence of objects."

	^ position
]

{ #category : #all }
ReadStream >> position: anInteger [
	"Set my current position to anInteger, as long as anInteger is within bounds. If not, report an error."

	anInteger >= 0 & (anInteger <= readLimit)
		ifTrue: [ position := anInteger asInteger ]
		ifFalse: [ self error: 'Position out of bounds: ' , anInteger printString ]
]

{ #category : #all }
ReadStream >> size [
	"Compatibility with other streams (e.g., FileStream)"

	^ readLimit
]

{ #category : #all }
ReadStream >> skip: anInteger [
	"Set the receiver's position to be the current position+anInteger."

	self position: (position + anInteger min: readLimit)
]