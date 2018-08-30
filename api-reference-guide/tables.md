---
layout: default
title: Tables Plugin
title_nav: Tables Plugin
description: Tables is a TinyMCE UI component that adds table management functionality to the TinyMCE editor.
keywords:
---

## Introduction

- Old note: Apollo will deprecate the Advanced tab in the table properties dialog. New styling should be done via css and not inline styles
New note: Style field was removed but the rest of the advanced tab remains.

---

Usually accessed via the Table menu or Table context menu (right click)
 • Table Properties
 • Row > Row Properties
 • Cell > Cell Properties

They can also be added to the toolbar, but aren't included by default.

Changes between Tiny 4 and Apollo:
 • Styles text field has been removed from the advanced table of the dialogs. Much less confronting/confusing for non-dev users, and means we have more control over the table styles and therefore are better able to ensure the styles are correct
 • Related, put some work into improving how styles are set and retrieved from tables/rows/cells, so should be more reliable
 • Shifted to using CSS more for styling, and therefore was able to remove a few legacy data attributes that we were setting on tables/rows/cells which are no longer good practice to use. Html is now cleaner and shorter
 • When opening a properties dialog with a single table/row/cell selected, the dialog will autofill with the relevant existing values. If you select multiple rows or cells and open the relevant properties dialog, Tiny 4 will leave all the dialog fields blank. In Apollo, any fields which have the same values for all the selected rows or cells will autofill, and the fields which have no existing value or have differing values will be empty.
 • "Border" input field in the tableprops dialog is now called "Border width", for clarity


Docs:
 • tiny docs are mostly still correct, and the code snippets there are pretty good.
   ∘ in my demo page, when testing table_class_list, table_row_class_list and table_cell_class_list I added the following to my config so applying the classes would actually make a visible difference in the editor: " content_style: '.cat { border-color: green; color: red; background-color: }' "
   ∘ comparisons between the accessible and non-accessible ways of adding tables could be useful, since we know quite a few people go looking for the accessibility options
 • tbio docs - irrelevant, nothing on tables

The following hasn't changed much from the current Tiny docs, but I'm listing it all out anyway for completion's sake and so I could run through it all in my head, to ensure I didn't miss anything

tableprops dialog UI:
 • General tab:
   ∘ Width: table width
   ∘ Height: table height
   ∘ Cell spacing: padding between cells
   ∘ Cell padding: padding within cells
   ∘ Border width: ditto
   ∘ Caption checkbox: adds a caption element above the table so you can type in a caption
   ∘ Alignment: alignment of the table within it's parent, using float or margin CSS styles
 • Advanced tab:
   ∘ Border style: standard css border for the *outside* of the table
   ∘ Border color: set border colour for the *whole* table
   ∘ Background color: ditto for table

rowprops dialog UI:
 • General tab:
   ∘ Row type: set as header, body or footer row
   ∘ Alignment: text alignment for that row
   ∘ Height: row height
 • Advanced tab:
   ∘ Border style: set border style for the row
   ∘ Border color: inner border colour for that row
   ∘ Background color: ditto for row

cellprops dialog UI:
 • General tab
   ∘ Width: cell width
   ∘ Height: cell height
   ∘ Cell type: set as cell or header cell
   ∘ Scope: ???
   ∘ H align: horizontal text alignment within the cell
   ∘ V align: vertical text alignment within the cell
 • Advanced tab:
   ∘ Border style: set border style for the cell
   ∘ Border color: set border color for the cell
   ∘ Background color: ditto for cell


API
 • available toolbar and context toolbar buttons:
   ∘ table (currently undocumented) - replicates the Table menu but allows it to be opened from a toolbar button. could be useful if menubars are turned off?
   ∘ tableprops
   ∘ tablerowprops (currently undocumented) - opens row properties dialog
   ∘ tablecellprops (currently undocumented) - opens cell properties dialog
   ∘ tabledelete
   ∘ tableinsertrowbefore
   ∘ tableinsertrowafter
   ∘ tabledeleterow
   ∘ tableinsertcolbefore
   ∘ tableinsertcolafter
   ∘ tabledeletecol
 • tableprops dialog options:
   ∘ table_advtab: true by default, if false hides the advanced tab of the table properties dialog
   ∘ table_class_list: takes a list of objects containing title and value properties. if specified, adds a drop down to the general tab of the dialog
 • tablerowprops dialog options:
   ∘ table_row_advtab: true by default, if false hides the advanced tab of the table row properties dialog
   ∘ table_row_class_list: takes a list of objects containing title and value properties. if specified, adds a drop down to the general tab of the dialog
 • tablecellprops dialog options:
   ∘ table_cell_advtab: true by default, if false hides the advanced tab of the table cell properties dialog
   ∘ table_cell_class_list: takes a list of objects containing title and value properties. if specified, adds a drop down to the general tab of the dialog
 • general:
   ∘ table_toolbar
   ∘ table_appearance_options
   ∘ table_clone_elements
   ∘ table_grid: disables the table grid in the table menu that's usually used to insert tables. replaces it with a button that opens a dialog like the tableprops dialog, but with two extra fields added: rows and cols, which are used to set how many rows and cols the user wants the table to have. essentially exists for accessibility reasons, since the table grid isn't accessible and never will be.
   ∘ table_tab_navigation
   ∘ table_default_attributes
   ∘ table_default_styles

Commands:
Currently not documented anywhere that I can tell, but these are all commands that can be run via " tinymce.execCommand(<cmd>) " in JS or the console, as far as I can tell.
• mceTableSplitCells
• mceTableMergeCells
• mceTableInsertRowBefore
• mceTableInsertRowAfter
• mceTableInsertColBefore
• mceTableInsertColAfter
• mceTableDeleteCol
• mceTableDeleteRow
• mceTableCutRow (grid)
• mceTableCopyRow (grid)
• mceTablePasteRowBefore (grid)
• mceTablePasteRowAfter (grid)
• mceTableDelete
• mceInsertTable
• mceTableProps
• mceTableRowProps
• mceTableCellProps

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



