# playground_app

Playground application

## Getting Started

*Widget* - configuration of an element
    Properties:
        - Immutable
        - Can be used none or more times thanks to it's immutability
    What it does:
        - Describes a part of a UI
        - Defines which element it is associated with
        - Defines which render object (if any) it is associated with

*Element* - instantiation of a widget in a particular location of an element tree
    Properties:
        - Mutable
        - Has links to both widget and render object
    What it does:
        - Updates render object whenever widget configuration changes

*Render object* - object responsible for layout, composition and painting.