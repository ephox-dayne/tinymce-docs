---
layout: default
title: Dialog
title_nav: Dialog
description: Dialog is a TinyMCE UI component used to display simple information.
keywords: dialog dialogapi
---

## Introduction

This chapter describes migration and workarounds if you are using an older version of TinyMCE. It includes tasks that you must perform before the migration can begin, and different workaround procedures for deprecated and updated features.

## Use Cases


* To display simple information (eg: source code plugin, displays the HTML code from the content in the dialog)

** These dialogs need a way to set the desired content into the dialog

* To display complex information, sections can be contained within tabs ( eg: help dialog or special chars dialog are tabbed dialogs),

** These dialogs needs a way to set the desired content into a defined tab section

* Interactive dialogs use web forms to collect interaction data, and then apply the data  (eg: search and replace dialog, uses an input field.  Where the input text will be used as the search key)
** These are the most complexed forms of dialogs and requires the ability to define what data is required, and how to get that data when we need it, and how to set the data to what we want.


## Authentication

<Text>

## Composition

A dialog is a tinymce Ui component.  Tinymce has many Ui components <list all the components>.  We can use these components inside our dialogs to fulfill a use case.  For example the search and replace dialog is made up of 2 input fields, 2 check boxes and 5 buttons.  We compose components by using a configuration structure.  The most basic configuration structure is this

### Example

```js
const dialogConfig = {
   title: 'Just a title',
   body: {
     type: 'panel', <note: the root body type can only be of type Panel or TabPanel, see component definitions for panel or tabpanel>
     items: []      <a list of ui component configurations the dialog will have>
   },
   buttons: []    <a list of button configurations the dialog will have>
}
```
`tinymce.activeEditor.windowManager.open`(conf), pass the config to the open method will create a dialog, with the title ‘Just a title’, an empty body and an empty footer without buttons.


To demonstrate how data flows through the dialog, how buttons are configured, …. More… we will create a dialog that inserts the name of a cat into the editor content on submit.

### Example

```js
// example dialog that inserts the name of a cat into the editor content
const dialogConfig = {
   title: 'Insert Cat Name',
   body: {
     type: 'panel',
     items: [
       {
         type: 'input',
         name: 'catdata',
         label: 'enter the name of a cat'
       }
     ]
   },
   buttons: [
     {
       type: 'submit',
       name: 'submitButton',
      text: 'Do Cat Thing',
        primary: true,
      },
      {
        type: 'close',
        name: 'closeButton',
        text: 'cancel'
      }
    ],
    initialData: {
      catdata: 'initial Cat'
    },
    onSubmit: (api) => {
      const data = api.getData();
      tinymce.activeEditor.execCommand('mceInsertContent', false, '<b>My cats name is:</b>, ' + data.foodata);
    }
 }
```
The key highlight in this example is the input field for ‘enter the name of a cat’, the name property ‘catdata’ is associated to the initalData.  All body components that require a name property also require an initialData property, this is how the relationship between the underlaying data model and the component is declared.  Notice that when we first load the dialog, the input field is pre-populated with ‘initial cat’.

In this example we declared 2 buttons to be placed in the dialog footer, Close and Submit.  These are pre-made buttons that perform common actions, like closing a dialog or submiting a dialog, we will move onto a third type ‘custom’ button later.  The type: ‘close’ button is pre-wired to just abort and close the dialog.  The type: ‘submit’ button when clicked will invoke the onSubmit callback provided in the configuration, and we use that callback to insert the message.  When onSubmit is called its called with 2 args, the first is the dialogApi <see here {somewhere}>, the second parameter returns

## Component Definition

Ui Components types and their definitions/what they do/why they needed/

### Panel

is a basic container, that holds other components, we can compose many components inside a panel.  In HTML terms consider a panel a <div> wrapper.  A dialog body configuration must begin with either a Panel or a TabPanel

```js
var panelConfig = {
  type: 'button',
  items: []
};
```
> Insert Table: Items: Array of component configurations, any component listed in ‘Component Definitions’ are compatible

### TabPanel

is similar to a Panel, where it can holder other components.  We can separate components by tab sections.  Each tab can hold different components which display different information for the user that is grouped by tabs.  A dialog body configuration must begin with either a Panel or a TabPanel

```js
var tabPanelConfig = {
  type: 'tabpanel',
  tabs: [
    {
      title: string,
      items: []
    },
    …
  ]
};
```
> Insert Table: tabs: Array of tab configurations.  Each tab has a title which is used to reference the tab.  The items property in the tab configuration takes a list of components and works the same way as a Panel.  We can programmatically switch to a tab by calling dialogApi.showTab(‘title’), see dialogApi for more details

### Button

to create a button inside the dialog body

```js

var buttonConfig = {
  type:  'button'
  name: string,
  text: string,
  disabled: boolean,
  primary: boolean
}

```
> Insert Table: Name: The name property on the button is used to identify which button was clicked. The name property is used as an id attribute to identify dialog components. When we define name: ‘foobutton’ and a user clicks on that button.  The dialog onAction handler will fire and provide event details.name will be ‘foobutton’ this will allow developers to create a click handler for ‘foobutton’  see dialog onAction configuration.

                Text: This will be the displayed button text, eg: text: ‘do magic’ will create a button with text ‘do magic’, dialog buttons do not support icons at the moment
                Disabled: boolean, (defaults to false) when set to true, the button will be disabled when the dialog loads.  To toggle between disabled and enabled states, use dialogApi.enable(name) or dialogApi.disable(name) -> see dialogApi

                Primary: (defaults to false)  when set to true, the button will be colored to standout.  The color will depend on the chosen skin


## Methods

<Text>

### Display Information

<Text>


### Display Complex Information

<Text>

### Interactive Dialogs

<Text>



