$(document).ready(function(){
  function change(){
    $('body').on('click', '.form-control', function() {
      console.log("hey");
      test();
    });
  }
  change();
});

function test(){
  $('.form-control').on('input', function() {
    console.log("heyaaa");
  });
}
