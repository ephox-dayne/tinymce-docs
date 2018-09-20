tinymce.init({
  selector: '#editor',
  height: 300,  
  plugins: 'code',
  toolbar: 'undo redo | currentdate',
  content_css: [
    '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
    '//www.tinymce.com/css/codepen.min.css'],
  
  setup: function(editor) {
    
    function toTimeHtml(date) {
      return '<time datetime="' + date.toString() + '">' + date.toDateString() + '</time>';
    }
    
    function insertDate() {
      var html = toTimeHtml(new Date());
      editor.insertContent(html);
    }
    
    function monitorNodeChange() {
      var btn = this;
      editor.on('NodeChange', function(e) {
        btn.disabled(e.element.nodeName.toLowerCase() == 'time');
      });
    }

    editor.addButton('currentdate', {
      icon: 'insertdatetime',
      //image: 'http://p.yusukekamiyamane.com/icons/search/fugue/icons/calendar-blue.png',
      tooltip: "Insert Current Date",
      onclick: insertDate,
      onpostrender: monitorNodeChange
    });
  }
});