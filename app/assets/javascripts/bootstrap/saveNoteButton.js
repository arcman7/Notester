
function ajaxRes(){
  $('#new_user').on('submit',function(e){
  console.log("ajaxRes BITCH");
    e.preventDefault();
    $.ajax({
      url: protocol +  '//' + domain +'/'+'user',
      type: "POST",
      data: $(this).serialize()//{ user: {username: , email: , password: } }
    }).done(function(response){
      if(response.errors){
        for(var key in response.errors){
          $('#new_user').append("<h5 style=\"color: red\">"+key+ " " + response.errors[key][0]+"!<\/h5> ");
        }
      }
      console.log(response);
    })//end ajax done
  })
};

$(document).ready(function(){

  document.getElementById("note-date").outerHTML = Date();

  var strSignIn="";
      strSignIn += "<section id=\"content\" class=\"m-t-lg wrapper-md animated fadeInUp\">";
      strSignIn += "  <div class=\"container aside-xxl\">";
      strSignIn += "    <a style=\"font-size:50px; color: #53b567;\"class=\"navbar-brand block\" href=\"\/\">Notester<\/a>";
      strSignIn += "    <section class=\"panel panel-default bg-white m-t-lg\">";
      strSignIn += "      <header class=\"panel-heading text-center\">";
      strSignIn += "        <strong>Sign in<\/strong>";
      strSignIn += "      <\/header>";
      strSignIn += "      <form action=\"\/user\" class=\"new_user\" class=\"panel-body wrapper-lg\" method=\"post\">";
      strSignIn += "        <div class=\"form-group\">";
      strSignIn += "          <label class=\"control-label\">Email<\/label>";
      strSignIn += "          <input type=\"email\" name=\"user[email]\" placeholder=\"test@example.com\" class=\"form-control input-lg\">";
      strSignIn += "        <\/div>";
      strSignIn += "        <div class=\"form-group\">";
      strSignIn += "          <label class=\"control-label\">Password<\/label>";
      strSignIn += "          <input type=\"password\" name=\"user[password]\" id=\"inputPassword\" placeholder=\"Password\" class=\"form-control input-lg\">";
      strSignIn += "        <\/div>";
      strSignIn += "        <button type=\"submit\" class=\"btn btn-primary\">Sign in<\/button>";
      strSignIn += "        <p class=\"text-muted text-center\"><small>Do not have an account?<\/small><\/p>";
      strSignIn += "        <a href=\"\/user\/new\" class=\"btn btn-default btn-block\">Create an account<\/a>";
      strSignIn += "      <\/form>";
      strSignIn += "    <\/section>";
      strSignIn += "  <\/div>";
      strSignIn += "<\/section>";

    var strSignUp="";
        strSignUp += "<section id=\"content\" class=\"m-t-lg wrapper-md animated fadeInDown\">";
        strSignUp += "  <div class=\"container aside-xxl\">";
        strSignUp += "    <a style=\"font-size:50px; color: #53b567;\"class=\"navbar-brand block\" href=\"index.html\">Notester<\/a>";
        strSignUp += "    <section class=\"panel panel-default m-t-lg bg-white\">";
        strSignUp += "      <header class=\"panel-heading text-center\">";
        strSignUp += "        <strong>Sign up<\/strong>";
        strSignUp += "      <\/header>";
        strSignUp += "      <form action=\"\/user\" id=\"new_user\" class=\"new_user panel-body wrapper-lg\" method=\"post\">";
        strSignUp += "        <div class=\"form-group\">";
        strSignUp += "          <label class=\"control-label\">Username<\/label>";
        strSignUp += "          <input type=\"text\" name=\"user[username]\" placeholder=\"eg. Your Username\" class=\"form-control input-lg\">";
        strSignUp += "        <\/div>";
        strSignUp += "        <div class=\"form-group\">";
        strSignUp += "          <label class=\"control-label\">Email<\/label>";
        strSignUp += "          <input type=\"email\" name=\"user[email]\" placeholder=\"test@example.com\" class=\"form-control input-lg\">";
        strSignUp += "        <\/div>";
        strSignUp += "        <div class=\"form-group\">";
        strSignUp += "          <label class=\"control-label\">Password<\/label>";
        strSignUp += "          <input type=\"password\" name=\"user[password]\" id=\"inputPassword\" placeholder=\"Type a password\" class=\"form-control input-lg\">";
        strSignUp += "        <\/div>";
        strSignUp += "        <button type=\"submit\" onClick=\"ajaxRes()\" class=\"btn btn-green\">Sign up<\/button>";
        strSignUp += "        <div class=\"line line-dashed\"><\/div>";
        strSignUp += "        <p class=\"text-muted text-center\"><small>Already have an account?<\/small><\/p>";
        strSignUp += "        <a href=\"\/session\/new\" id=\"signInLink\" onClick=\"signIn()\" class=\"btn btn-default btn-block\">Sign in<\/a>";
        strSignUp += "        <\/div>";
        strSignUp += "      <\/form>";
        strSignUp += "    <\/section>";
        strSignUp += "  <\/div>";
        strSignUp += "<\/section>";

  var saveNoteButton = document.getElementById("save-note");



  var signUp = function(){
    if (localStorage.notesterUser !== 'Anon' && localStorage.notesterUser !== undefined){ //means we're logged in
      saveNoteButton.addEventListener('click', function(){
       bootbox.prompt("Title name:", function(result) {
          var date = new Date();
          var title = result || "note title" + date.toString(),
              description = document.getElementsByClassName("form-control"),
              user_email = document.getElementById("storageUsername");
            $.ajax({
              type: "POST",
              url: protocol +  '//' + domain +'/'+'resource',
              data: new ResourceModel(title,description,user_email)
            })
          })
        });//end event listener
    }
    else {
      saveNoteButton.addEventListener('click', function(){
            bootbox.alert(strSignUp, function() {//preventing signup form default
          });
          // $('#new_user').on('submit',function(e){
          //       e.preventDefault();
          //       $.ajax({
          //         url: protocol +  '//' + domain +'/'+'user',
          //         type: "POST",
          //         data: $(this).serialize()//{ user: {username: , email: , password: } }
          //       }).done(function(response){
          //         console.log(response);
          //       })//end ajax done
          //     })
      })
    }
  }
  signUp();

 var signInLink = document.getElementById("signInLink");
 var signIn = function(){
    signInLink.addEventListener('click', function(){
        bootbox.alert(strSignIn, function() {
        });
    })
  }

});
