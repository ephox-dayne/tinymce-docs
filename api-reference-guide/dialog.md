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
** These are the most complex forms of dialogs and requires the ability to define what data is required, and how to get that data when we need it, and how to set the data to what we want.


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


To demonstrate how data flows through the dialog, how buttons are configured, …. More… we will create a dialog that inserts the name of a cat into the editor content on submit.  We will refer to this example as we walk through the new dialog instance api.

### Example Simple - Pet Name Machine

```js
// example dialog that inserts the name of a Pet into the editor content
const dialogConfig =  {
  title: 'Pet Name Machine',
  body: {
    type: 'panel',
    items: [
      {
        type: 'input',
        name: 'catdata',
        label: 'enter the name of a cat'
      },
      {
        type: 'checkbox',
        name: 'isdog',
        label: 'tick if cat is actually a dog'
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
    catdata: 'initial Cat',
    isdog: 'unchecked'
  },
  onSubmit: (api) => {
    const data = api.getData();
    const pet = data.isdog === 'checked' ? 'dog' : 'cat';

    tinymce.activeEditor.execCommand('mceInsertContent', false, `<b>My #{pet}'s name is:</b>, #{data.catdata}`);
  }
}
```
The key highlight in this example is the input field for ‘enter the name of a cat’, the name property ‘catdata’ is associated to the initalData.  All body components that require a name property also require an initialData property, this is how the relationship between the underlaying data model and the component is declared.  Notice that when we first load the dialog, the input field is pre-populated with ‘initial cat’.  When initialData.catdata = '' then on load, the input field should be empty.

In this example we declared 2 buttons to be placed in the dialog footer, Close and Submit.  These are pre-made buttons that perform common actions, like closing a dialog or submiting a dialog, we will move onto a third type ‘custom’ button later.  The type: ‘close’ button is pre-wired to just abort and close the dialog.  The type: ‘submit’ button when clicked will invoke the onSubmit callback provided in the configuration, and we use that callback to insert the message.  When onSubmit is called, a dialog instanceApi is passed in as the parameter.

## Dialog Instance Api
When a dialog is created, a dialog instanceApi is returned.  For example 

```js
  const instanceApi = editor.windowManager.open(config);
```

The instanceApi is a javascript object containing methods attached to the dialog instance.  When the dialog is closed, the instanceApi is destroyed.

## instanceApi Methods

### getData(): <T>
getData() returns a key value object matching the structure of the initialData -> see initialData configuration
The object keys in the returned data object represents a component name.  For the Insert Cat Name example, data.catdata is the value currently being held by the input field with the name 'catdata'

### setData(newConfig: object): void
setData(newData) updates the dataset.  This method also works with partial data sets.

### disable(name: string): void
Calling disable and passing the component name will disable the component.  Calling enable(name) will re-enable the component. 

### enable(name: string): void
Calling enable and passing the component name will enable a component, and users can interact with the component.

### focus(name: string): void
Calling focus and passing the component name will set browser focus to the component.

### block(message: string): void
Calling block and passing a message string will disable the entire dialog window and display the message notifying users why the dialog is blocked, this is useful for asynchronous data.  When the data is ready we use unblock() to unlock the dialog

### unblock(): void
Calling unblock will unlock the dialog instance restoring functionality

### showtab(name: string): void
This method only applies to tab dialogs only. <todo insert tab dialog demo link> Calling showtab and passing the name of a tab will make the dialog switch to the named tag.

### close(): void
Calling the close method will close the dialog.  When closing the dialog, all DOM elements and dialog data are destroyed.  When open(config) is called again, all DOM elements and data are recreated from the config.

### redial(config): void
Calling redial and passing a dialog configuration, will destroy the current dialog and create a new dialog.  Redial is used to create a multipage form, where the next button loads a new form page.  See example <insert here Redial Demo>


### Redial Demo
```
// example Redial dialog that demonstrates custom buttons

const dialogConfig = {
  title: 'Redial Demo',
  body: {
    type: 'panel',
    items: [{
      type: 'htmlpanel',
      html: '<p>Redial allows the creation of multi-page forms.</p><p>The Next button has been configured to be disabled. When the <b>checkbox</b> is checked, the next button should be enabled</p>'
    }, {
      type: 'checkbox',
      name: 'anyterms',
      label: 'I agree to disagree'
    }, {
      type: 'htmlpanel',
      html: '<p>The next button, calls the redial method which reloads a new dialog in place</p><p>Press next to continue</p>'
    }]
  },
  initialData: {
    anyterms: 'unchecked'
  },
  buttons: [
    {
      type: 'custom',
      name: 'doesnothing',
      text: 'Previous',
      disabled: true
    },
    {
      type: 'custom',
      name: 'uniquename',
      text: 'Next',
      disabled: true
    }
  ],
  onChange: (dialogApi, changeData) => {
    const data = dialogApi.getData();

    // Example of enabling and disabling a button, based on the checkbox state.
    const toggle = data.anyterms === 'checked' ? dialogApi.enable : dialogApi.disable;
    toggle('uniquename');
  },
  onAction: (dialogApi, actionData) => {
    if (actionData.name === 'uniquename') {
      dialogApi.redial({
        title: 'Redial Demo - Page 2',
        body: {
          type: 'panel',
          items: [
            {
              type: 'selectbox',
              name: 'choosydata',
              label: 'Choose a pet',
              items: [
                { value: 'meow', text: 'Cat' },
                { value: 'woof', text: 'Dog' },
                { value: 'thunk', text: 'Rock' }
              ]
            },
            {
              type: 'htmlpanel',
              html: '<p>Click done, your pet choice will be printed in the console.log and the dialog should close</p>'
            }
          ]
        },
        buttons: [
          {
            type: 'custom',
            name: 'lastpage',
            text: 'Done',
            disabled: false
          }
        ],
        initialData: {
          choosydata: ''
        },
        onAction: (dialogApi, actionData) => {
          const data = dialogApi.getData();
          console.log('you chose wisely: ' + data.choosydata);
          dialogApi.close();
        }
      });
    } else if (actionData.name === 'doesnothing') {
      // this case should never be met as the button is never enabled.
    }
  }
}
```
In this redial example, we have 2 separate dialogs that we cycle through by pressing the Next button.  Looking at the configuration structure, the first level is like any other dialog.
The difference is the onAction call, loads a new configuration for the dialog using redial.  The configuration we use in the redial(dialogConf) call can be any supported dialog structure.  We could even replace the 'Redial Demo - Page 2' configuration, with the 'Pet Name Machine' dialog.

This demo also includes the use of dialogApi.enable and dialogApi.disable to disable the 'Next' button when a user input is required.  For checkboxes we use the onChange callback to handle the changes for the checkbox data.  The checkbox data is mapped to its defined name: 'anyterms'.  When a user clicks or presses enter on the checkbox, the new value of the checkbox is returned by the getData() call stored in the 'anyterms' property.  Given the state of the checkbox, we either disable or enable the Next button.

The onAction callback at the root level, is the handler for the 'Previous' and 'Next' buttons.  The onAction handler is shared across multiple buttons and we use the name property to identify the clicked button.  The Previous button named 'doesnothing' is used to highlight branching.  A switch statement could be used to handle many buttons.

The onAction callback inside the redial() call, is a separate handler for the redialed dialog.  Since there is only one button we don't check which named button triggered the click.
This handler demonstrates the dialogApi.close() api.


### TODO: insert more component definitions from
https://www.notion.so/tinycloud/Dialog-component-summary-ffac54a491214f18be28c64346ddf743

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


