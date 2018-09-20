tinymce.init({
  selector: 'textarea',
  height: 200,
  code_dialog_height: 200,
  plugins: 'bbcode code',
  toolbar: 'undo redo | bold italic underline | code',
  init_instance_callback: function (ed) {
    setTimeout(function () {
		  ed.execCommand('mceCodeEditor');
    }, 100);
	},
  content_css: [
    '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
    '//www.tinymce.com/css/codepen.min.css']
});