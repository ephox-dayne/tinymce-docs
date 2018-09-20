tinymce.init({
  selector: '#editor',
  height: 300,  
  plugins: 'code fullpage',
  toolbar: 'undo redo | strikeout | fullpage code',
  content_css: [
    '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
    '//www.tinymce.com/css/codepen.min.css'],
  
  setup: function(editor) {
    editor.addButton('strikeout', {
      icon: 'strikethrough',
      onclick: function() {
        editor.execCommand('mceToggleFormat', false, 'strikethrough');
      },
      onpostrender: function() {
        var btn = this;
        editor.on('init', function() {
          editor.formatter.formatChanged('strikethrough', function(state) {
            btn.active(state);
          });
        });
      }
    });
  }
 
});