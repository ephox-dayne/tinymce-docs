---
layout: default
title: Migrating from TinyMCE 4 to TinyMCE 5.
title_nav: Migrating
description: Instructions for migrating from TinyMCE 4 to TinyMCE 5.
keywords: migration considerations premigration pre-migration
---

## Migrating from Previous Versions

The new TinyMCE 5.0 editor comes with significant changes to the previous versions. The new editor offers an easier to navigate user interface.

Our team at Tiny has worked on creating a configurable, less cumbersome editor while retaining the familiarity of the user interface from the older versions.

This chapter describes the migration process and workarounds if you are using an older version of TinyMCE. It includes tasks that you must perform before the migration can begin, and different workaround procedures for deprecated, deleted, and updated features.


## Important Considerations

### API changes

What does the current API allow us to do?

* Add a button to the toolbar editor.addButton()
* Create a button and attach it anywhere tinymce.ui.Factory.create


What can’t it do now that we would like it to do later

* Share the Ui with TBIO
* editor.addButton will need to create an Alloy config, we will need various adaptors to make it work both ways. This adds complexity and maybe awkward code.

What can it do now that we don’t want it to do later

* When we set { cmd: ‘foobar” } it will overwrite any onclick functions declared (Editor.ts addButton)
* Some args can be String or String[]
* Some args can take either fn() or String
* on<event> exposes too much


### Features

### Plugins

### Themes

### Existing data


## Installation and integration

### Pre-Migration Tasks

Spike
* Create a simple theme with alloy, editor.buttons & editor.menuItems
* Create an equivalent API to add a button only
* Create a Demo, that uses Alloy silver api, that adds 3 buttons
* Change the theme to ‘modern’, expect those 3 buttons to be added
* Rinse and repeat with toolbars, submenus, todo list all these components in jira


Text

## Configuration options compatibility table
