# Microdown API

There is a lot of functionality in Microdown, and this document gives an overview of the Microdown architecture.

- Architecture - key objects in Microdown.
- Microdown facade methods.
- Resource references and resolvers. Dealing with links, images, and included documents.
- Document checkers: Microdown provides checkers that validate documents.

Several parts of Microdown allows for extending the Microdown tool suite. Chapter *@[Extension](extension.md)@* presents the mechanisms in place.

The full suite of microdown tools are not loaded by default. In particular there is also support for:
- Translation of Microdown to Latex and Beamer,
- Translation of Microdown to HTML,
- Translation from Pillar to Microdown, and
- Document checkers.

## Architecture
The overall idea in Microdown is like this:

![](https://www.planttext.com/api/plantuml/png/VP1D2u9048Rl-oi6xq9q35c4EdHG2fJkYmwofBioEqj2zDzJAoNxcECy3xmlR-nO4Vkc5iATjMaLgGO82rQcgX6k0leZwqsvjMIGOBqIDo5c8qXrGRQq5nF0IvzWPZqL256KCMbJIGaBOMSBtw3XNia9KSe5px4RsC5pw_c39egn-uttUPeiwRDH6CevUmD7HGvf5ARle8pn6pXffzb-uOy2VuInmZiVvelHbFtcTm00)

You can edit the figure using this source on planttext.com
```
@startuml
skinparam rectangle {
    roundCorner 20
}
rectangle "Microdown"  {
    rectangle Source <<String>> 
    rectangle Document <<Tree>>
    rectangle Text <<Output>>
    rectangle Latex <<Output>>
    rectangle HTML <<Output>>
    Source --> Document : Parser
    Document --> Text : Visitor
    Document --> Latex : Visitor
    Document --> HTML : Visitor   
}
@enduml 
```

The format of the source code is explained in the Chapter *@[Syntax](syntax.md)@*.

The parser translates the source code into an abstract syntax tree which we refer to as a "document". Translation into various output formats are done using visitors. By default only the visitor for translation into Pharo `Text` objects is in the image. Sometimes `Text` is refered to as `RichText` to emphasize its difference from plain character `String`.


## Microdown facade
### Parse and output generation
The class `Microdown` has facade methods for the main actions in the architecture.

- `Microdown class >> #parse:` translates a microdown source string into a document.
- `Microdown class >> #asRichText:` translates a document into rich text. `asRichText:` can also accept a source string directly, cirumventing the `parse:` method. 

There are two facade methods for _resolution_. 
- `Microdown class >> #resolveDocument:withBase:` and 
- `Microdown class >> #resolveString:withBase:`

The will be explained in the next section.

## Resolution and references

References to other documents or images can be either _absolute_ or _relative_. 

#### Absolute vs. relative references. 

A typical absolute reference is `[Pharo](https:pharo.org)` or `![](file:/path/to/image.png)`. Absolute references cause no problems for the visitors to find the image or follow the link.
However, when writing larger documents it is customary to keep images for the document in a seperate image folder, and refer to the images as `![](img/figure2.png)`. Such a reference is _relative_. It is relative to to location of the document containing the reference.

**Resolution** is the process of replacing all relative references with absolute references. This process takes two inputs:
- A document D containing relative references and
- The absolute location of document D (the base of the document).

The two methods 
- `Microdown class >> #resolveDocument:withBase:` and 
- `Microdown class >> #resolveString:withBase:`
are the prefered way to resolve documents.

### Resource references

If we go one level below this, references are first order objects, all subclasses of `MicResourceReference`.

In the standard image there are three kinds of absolute references:
- http (and https) - for example: 'https://pharo.org/web/files/pharo.png'
- file - for example 'file:/user/joe/docs/api.md'
- the pharo image - for example 'pharo:///Object/iconNamed:/thumbsUp' `(![](pharo:///Object/iconNamed:/thumbsUp))`
- 
#### Creating references

The prefered way is to use the extension method `asMicResourceReference`, which is defined for
- String - for example `'file:/user/joe/docs/api.md' asMicResourceReference`
- ZnUrl - for example `(ZnUri fromString: 'https://pharo.org/web/files/pharo.png') asMicResourceReference`
- FileReference - for example `(FileSystem memory) asMicResourceReference`

#### Using references

There are two main key methods on references:
- `loadImage` - returns a `Form` by reading the image (read using `ImageReadWriter class >> #formFromStream:`)
- `loadMicrodown` - loads _and resolves_  a document

#### Background

The resolution is done using `ZnUrl >> #withRelativeReference:`, which implements the full resolution standard [RFC 3986 Section 5](https://datatracker.ietf.org/doc/html/rfc3986#section-5).

##### Ambiguity of file uri

In pharo there is an issue that uri ' file://path/to/my/document.md' is ambiguous, because it can not be determined in which file system the path is supposed to be resolved (memory or disk).  This problem is dealt with, in the following manner:
- `' file://path/to/my/document.md' asMicResourceReference` will always use the disk file system
- `aFileReference asMicResourceReference` will create a `MicFileResourceReference` which remembers the file system in the file reference.
- `aMicFileResourceReference loadDocument` will use the right filesystem for resolution.

