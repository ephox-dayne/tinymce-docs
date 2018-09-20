tinymce.init({
  selector: 'textarea',
  height: 500,
  toolbar: 'mybutton',
  plugins: 'wordcount',
  menubar: false,
  content_css: [
    '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
    '//www.tinymce.com/css/codepen.min.css'],
  
  setup: function (editor) {
    editor.addButton('mybutton', {
      text: 'My button',
      icon: false,
      onclick: function () {
        editor.insertContent('&nbsp;<b>It\'s my button!</b>&nbsp;');
      }
    });
  }
});