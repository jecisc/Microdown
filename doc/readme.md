# Microdown

Microdown is the Pharo version of markdown. In general it is very close to github markdown, with two major differences and a number of smaller ones.

Principal differences:

Microdown has a number of extension points to allow new functionality to be added without introducing new markdown syntax. These extensions can be the level of main block such as environments or as inline element (such as footnote, citation). In particular Microdown has support for LaTeX, Pharo defined color highlighting of embedded code, inclusion of one document into another.

Microdown supports metadata for figure, equation, ... It allows one to have anchor.

## Syntax
[The Syntax Chapter](syntax.md) defines the syntax of Microdown.
[This Extension Chapter](extension.md) defines the extension mechanisms of Microdown.

## API
An important aspect of Microdown is its API, which allow you to work with Microdown from within Pharo.
[The Chapter API](api.md) explains the overall architecture of Microdown and the key methods.
