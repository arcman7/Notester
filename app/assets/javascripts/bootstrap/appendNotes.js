$(document).ready(function(){
  function textListener(){
    $('body').on('click', '.form-control', function() {
      createNote();
    });
  }
  textListener();
});

function createNote(){
  $('.form-control').on('input', function() {
    //console.log("heyaaa");
  });
}
