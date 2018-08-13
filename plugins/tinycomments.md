---
layout: default
title: Tiny Comments
description: Tiny Comments provides the ability to add comments to the content and collaborate with other users for content editing.
keywords: comments commenting tinycomments
---

## Introduction

The Tiny Comments plugin provides the user an ability to start or join a conversation by adding comments to the content within the TinyMCE editor. The Tiny Comments plugin is built upon the new [Annotations API]({{ site.baseurl }}/advanced/annotations/) and uses annotations to create comment threads (conversations).

This section describes the various configuration options for the Tiny Comments plugin.

## Considerations

### Storage

Like TinyMCE, the Tiny Comments plugin does not directly provide the user an ability to save the comments. You need to configure storage at your end to be able to store comments on your server. How you store those comments, and whether you choose to persist them immediately or save them at the same time as the content, affects when other users see new comments.

### Display Names

Tiny Comments expects each comment to contain the author's _display name_, not a user ID, as Tiny Comments does not know the user identities. Your implementation of `lookup` will most likely need to consider this and resolve user identifiers to an appropriate display name.

### Current Author

Tiny Comments does not know the name of the current user. After a user comments (triggering `create` for the first comment, or `reply` for subsequent comments) Tiny Comments requests the updated conversation via `lookup`, which should now contain the additional comment with the proper author. Determining the current user, and storing the comment related to that user, has to be done by the user.

## Implementation Functions

Tiny Comments requires four functions to be defined:

```
tinymce.init({
  ...
  tinycomments_create: create,
  tinycomments_reply: reply,
  tinycomments_delete: del,
  tinycomments_lookup: lookup
});
```

All functions incorporate `done` and `fail` callbacks as parameters. The function return type is not important, but all functions must call one of these two callbacks. If you are persisting the comments to a form field to be persisted on document save, you likely would call the appropriate callback prior to the function returning. However, if you are persisting comments directly back to a server as they are made, you would call them asynchronously after the network call to do so had completed.

## Example

To create the Tiny Comments plugin, use the following example:

```js
`function example(contentSelector, commentSelector) {
    
      /********************
       * Helper functions *
       ********************/
    
      function getConversation(uid) {
        var el = document.querySelector(commentSelector);
        return JSON.parse(el.value)[uid];
      }
    
      function setConversation(uid, conversation) {
        var el = document.querySelector(commentSelector);
        var store = JSON.parse(el.value);
        store[uid] = conversation;
        el.value = JSON.stringify(store, null, 2);
      }
    
      function deleteConversation(uid) {
        var el = document.querySelector(commentSelector);
        var store = JSON.parse(el.value);
        delete store[uid];
        el.value = JSON.stringify(store, null, 2);
      }
    
      function getAuthorDisplayName(authorId) {
        var authors = {
          'other': 'A Prior User',
          'demo': 'Demo User'
        };
        return authors[authorId] || 'Unknown';
      }
    
      function randomString() {
        // ~62 bits of randomness, so very unlikely to collide for <100K uses
        return Math.random().toString(36).substring(2, 14);
      }
    
      var authorId = 'demo';
    
      /********************************
       *   Tiny Comments functions    *
       * (must call "done" or "fail") *
       ********************************/
    
    /**
     * Conversation "create" function. Saves the comment as a new conversation,
     * and asynchronously returns a conversation unique ID via the "done"
     * callback.
     */
      function create(content, done, fail) {
        if (content === 'fail') {
          fail(new Error('Something has gone wrong...'));
        } else {
          var uid = 'annotation-' + randomString();
          setConversation(
            uid,
            [ { user: authorId, comment: content } ]
          );
          done(uid);
        }
      }
    
    /**
     * Conversation "reply" function. Saves the comment as a reply to the
     * an existing conversation, and asynchronously returns via the "done"
     * callback when finished.
     */
      var reply = function(uid, content, done, fail) {
        var comments = getConversation(uid);
        comments.push({
          user: authorId,
          comment: content
        });
        setConversation(uid, comments);
        done();
      }
    
    /**
     * Conversation "delete" function. Deletes an entire conversation.
     * Returns asynchronously whether the conversation was deleted.
     * Failure to delete due to permissions or business rules is indicated
     * by "false", while unexpected errors should be indicated using the
     * "fail" callback. 
     */
      function del(uid, done, fail) {
        // only allow first commenter to delete
        if (getConversation(uid)[0].user === authorId) {
          deleteConversation(uid);
          done(true);
        } else {
          done(false);
        }
      }
    
    /**
     * Conversation "lookup" function. Retreives an existing conversation
     * via a conversation unique ID. Asynchronously returns the conversation
     * via the "done" callback.
     *
     * Conversation object structure:
     * {
     *   "comments": [
     *     <comment1>,
     *     <comment2>,
     *     ...
     *   ]
     * }
     * 
     * Comment object structure:
     * {
     *   "author": "Author Display Name",
     *   "content": "This is the text of the comment"
     * }
     * 
     */
      function lookup(uid, done, fail) {
        var comments = getConversation(uid).map(function(item) {
          return {
            author: getAuthorDisplayName(item.user),
            content: item.comment
          };
        });
        done({ comments: comments });
      };
    
      tinymce.init({
        selector: contentSelector,
        toolbar: 'bold italic underline | tinycomments',
        plugins: 'tinycomments',
        tinycomments_css_url: '../../../dist/tinycomments/css/tinycomments.css',
        content_style: '.mce-annotation { background: yellow; color: black; } .tc-active-annotation {background: lime; color: black; }',
        tinycomments_create: create,
        tinycomments_reply: reply,
        tinycomments_delete: del,
        tinycomments_lookup: lookup
      });
    };
```

### Create

Tiny Comments uses the Conversation `create` function to create a comment. 

#### Helper Functions

* **setConversation(uid, conversation)**
`setConversation` here is a function written to synchronously persist the new conversation to a form field for submission to the server later.

* **randomString()**
`randomString()` here is a function used in the `create` function to return a 62-bits random strings to provision a large number of UIDs.

The `create` function saves the comment as a new conversation and returns a unique conversation ID via the `done` callback. If an unrecoverable error occurs, it should indicate this with the `fail` callback.

Here is an example of how `create` can be implemented:

```js
var currentAuthorId = ...
function create(content, done, fail) {
  // `randomString` should be written to produce random strings with a very low
  // chance of collisions.
  var uid = 'annotation-' + randomString();
  try {
    // `setConversation` here is a function written to synchronously persist
    // the new conversation to a form field for later submission to the server
    setConversation(
      uid,
      [ { user: currentAuthorId, comment: content } ]
     );
     done(uid);
   } catch {
    fail(new Error('Error creating conversation...'));
  }
}
```

### Reply

Tiny Comments uses the Conversation `reply` function to reply to a comment. 

#### Helper Functions

* **setConversation(uid, conversation)**
`setConversation` here is a function written to synchronously write the comment back to the form field, awaiting persist on document save.

* **getConversation(uid)**
`getConversation` here is a function written to synchronously retrieve an existing conversation from a form field populated by the server.

The `reply` function saves the comment as a reply to an existing conversation and returns via the `done` callback once successful. Unrecoverable errors are communicated to TinyMCE by calling the `fail` callback instead.

Here is an example of how `reply` can be implemented:

```js
var currentAuthorId = ...
function reply(uid, content, done, fail) {
  try {
    // "getConversation" here is a function written to synchronously retrieve an
    // existing conversation from a form field populated by the server.
    var comments = getConversation(uid);
    // Add comment to the conversation
    comments.push({
      user: currentAuthorId,
      comment: content
    });
    // Synchronously write the comment back to the form field, awaiting persist
    // on document save.
    setConversation(uid, comments);
    done();
  } catch {
     fail(new Error('Error replying to conversation...'));
   }
}

```

### Delete

Tiny Comments uses the Conversation `delete` function to delete an entire conversation. 

#### Helper Functions

* **deleteConversation(uid)**
`deleteConversation(uid)` here is to allow only the first commenter to delete a comment.

* **getConversation(uid)**
`getConversation` here is a function written to synchronously retrieve an existing conversation from a form field populated by the server.

The `delete` function should asynchronously return a flag indicating whether the comment/comment thread was removed using the `done` callback. Unrecoverable errors are communicated to TinyMCE by calling the `fail` callback instead.

Here is an example of how `delete` can be implemented:

```js
function del(uid, done, fail) {
  try {
    // only allow first commenter to delete
    if (getConversation(uid)[0].user === authorId) {
      deleteConversation(uid);
      done(true);
     } else {
       done(false);
     }
   } catch {
     fail(new Error('Error deleting conversation...'));
   }
}
```

> Note: Failure to delete due to permissions or business rules is indicated by "false", while unexpected errors should be indicated using the "fail" callback.


### Lookup

Tiny Comments uses the Conversation `lookup` function to retrieve an existing conversation via a conversation unique ID.

The conventional conversation object structure that should be returned via the `done` callback is as follows:

#### Conversation object

```js
{
 "comments": [
  <comment1>,
  <comment2>,
  ...
 ]
}

```
#### Comment object

```js
{
  "author": "Author Display Name",
  "content": "This is the text of the comment"
}

```
#### Helper Functions

* **getAuthorDisplayName(uid)**
`getAuthorDisplayName(authorID)` here is a function to retrieve an existing conversation via a conversation UID (`authorID` in our example).

* **getConversation(uid)**
`getConversation` here is a function written to synchronously retrieve an existing conversation from a form field populated by the server.

Here is an example of how `lookup` might be implemented, utilizing an in-memory lookup function to resolve author display names:

```
function lookup(uid, done, fail) {
  try {
    var comments = getConversation(uid).map(function(item) {
      return {
        author: getAuthorDisplayName(item.user),
        content: item.comment
      };
    });
    done({ comments: comments });
  } catch {
    fail(new Error('Error looking up conversation...'));
  }
}

```

We also have a [demo]({{ site.baseurl }}/enterprise/tiny-comments/#tinycommentsdemo) to showcase the Tiny Comments functionality.

For more information on Tiny Comments commercial feature, visit our [Premium Features]({{ site.baseurl }}/enterprise/tiny-comments/) page.