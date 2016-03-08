localStorage["notes-app"] = ""; //controller
var storageKeys  = [];           //controller
function setKeys(){
  for(var i=33; i<127; i++){
    storageKeys.push( String.fromCharCode(i) );
  }
}
setKeys();                       //controller
var storageIndex = 0;            //controller

var route = "resource";

function id(){ return storageKeys[storageIndex] };
function htmlTemplate(idd){ //view
  var idd =  ( idd || id() );
  strVar = ""
  strVar += "<li class=\"list-group-item hover active\" >";
  strVar += "                      <div class=\"view\">";
  strVar += "                        <button class=\"destroy close hover-action\">×<\/button>";
  strVar += "                        <div class=\"note-name\">";
  strVar += "                          <strong>";
  strVar += "                            Note Title";
  strVar += "                          <\/strong>";
  strVar += "                        <\/div>";
  strVar += "                        <div class=\"note-subject\">";
  strVar += "                          Subject";
  strVar += "                        <\/div>";
  strVar += "                        <span class=\"text-xs text-muted\"><\/span>";
  strVar += "                      <\/div>";
  strVar += "                      <div hidden class='storageIndex'>"+idd+"</div>";
  strVar += "                    <\/li>";
  return strVar;
}

function MetaModelConstructor(){  //controller-model ??
  var properties = [];
  var behavior   = [];
   for(var i=0; i < arguments.length; i++){
      if(typeof(arguments[i]) !== "function" && typeof(arguments[i]) !== "object"){
        properties.push(arguments[i]);
      }
      if(typeof(arguments[i]) === "object" ){
        behavior.push(arguments[i]);
      }
   }
  //console.log(properties)
  var ModelConstructor = function(){
    for(var i =0; i< properties.length; i++){
       this[properties[i]] = arguments[i]; //set up property assignment arguments
    }
  };

  for(var i=0; i<behavior.length; i++){
    for(key in behavior[i]){
      Model.prototype[key] = behavior[i][key]; //assign function-behavior to prototype
    }
  };
  return ModelConstructor;
}

Note = MetaModelConstructor('user',"title","subject",'description'); //Note() is the Note constructor

function addNote(id){             //view
  var noteContainer = $('#note-items');
  //console.log("noteContainer: ",noteContainer)
  if(id){
    storageIndex = noteContainer.append(htmlTemplate(id));
    return;
  }
  destroyNoteListener(noteContainer); //controller-view
  noteContainer.append(htmlTemplate());  //view
  //console.log("addNote-htmlTemplate() called")
  bindFocus(noteContainer);                           //controller
  var note = new Note(localStorage.notesterUser, "blank","blank","blank");
  //console.log(JSON.stringify(note))
  $('#note-text-area').val(note.description);
  localStorage["notes-app-"+storageKeys[storageIndex]] = JSON.stringify(note); //controller?
  sessionStorage.notesterIdFocus = storageKeys[storageIndex] //set the focus to the new note dom object //controller

  storageIndex++;
}

//add listner that binds note on focus (listner events for note tab clicked) with changes in textarea
function bindFocus(container){//clicking inside a the tab sets localStorage.notesterFocus
  container.on('click','.list-group-item',function (e){
    var storageId = $(this).children('.storageIndex').text();   //controller
    //localStorage.notesterIdFocus = storageId;                     //controller
    console.log("storageId: ",storageId);
    sessionStorage.notesterIdFocus = storageId;
    $('.active').removeClass('active');
    $(this).addClass('active');
    if(localStorage["notes-app-"+storageId]){               //controller
      var noteObject = JSON.parse(localStorage["notes-app-"+storageId]);
      $('#note-title').text(noteObject.title);          //view
      $('#note-text-area').val(noteObject.description); //view
    }

  });//on click end
}

function createNoteListener(){ //controller
  $('#new-note').on('click',function(e){
    console.log("create button clicked");
    $('.active').removeClass('active');
    addNote();
  });//on click end
}

function updateNoteContentListener(){
  $('#note-text-area').bind('input propertychange', function() {
     //var storageId = localStorage.notesterIdFocus;
     var storageId = sessionStorage.notesterIdFocus;
    if( sessionStorage.loggedInStatus ){ //is the user logged in?
      console.log(" NO pre-existing note: ",!localStorage["notes-app-"+storageId])
      if(!localStorage["notes-app-"+storageId] ){
        addNote();
      }
    }
     var storageId = sessionStorage.notesterIdFocus;
     console.log("storageId: ",storageId)
     var noteObject = JSON.parse(localStorage["notes-app-"+storageId]);
     console.log(noteObject);
     noteObject.description = $('#note-text-area').val();
     localStorage["notes-app-"+storageId] = JSON.stringify(noteObject);
  }); //bind end
}

function destroyNoteListener(container){ //view + model
  container.on('click','.destroy',function (e){
    var noteDiv = $(this).parent().parent();
    var storageId = noteDiv.children('.storageIndex').text();
    delete localStorage['notes-app-' + storageId]; //remove from storage //model
    noteDiv.remove(); //view-controller
  });
}

function reIndexModels(){ //model management/maintanence
 var counter = 0;
 var newKey;
 for(key in localStorage){
  //1. take key and make new key
  if(key.includes('note-app-')){
    newKey = storageKeys[counter];
    localStorage["note-app-" + newKey] = localStorage[key];
    addNote(id);
    delete localStorage[key];
    counter++;
  }
 }//end for
}

function editNoteListener(container){
  container.on('dblclick', '.list-group-item', function (e){
     var noteTitle   = $(this).children().children('.note-name').text().trim();
     var noteSubject = $(this).children().children('.note-subject').text().trim();
     var note        = $(this);
    //  console.log(noteTitle,noteSubject);
    // $(this).html('<input type="text" placeholder="'+noteTitle+'"><br>'+'<input type="text" placeholder="'+noteSubject+'">')//.focus();
    // $(this).html().focus();
    var idd = sessionStorage.notesterIdFocus;

    bootbox.dialog({
      title  : 'Edit Note',
      message: '<input class="bootbox-input bootbox-input-text form-control" id="editNoteTitle" type="text" placeholder="'+noteTitle+'"><br><input class="bootbox-input bootbox-input-text form-control" id="editNoteSubject" type="text" placeholder="'+noteSubject+'">',
      buttons: {
        save: {
            label: 'Save',
            callback: function(){
              var editNoteSubject = $('#editNoteSubject').val();
              var editNoteTitle   = $('#editNoteTitle').val();
              var strVar = "";
              strVar += "                      <div class=\"view\">";
              strVar += "                        <button class=\"destroy close hover-action\">×<\/button>";
              strVar += "                        <div class=\"note-name\">";
              strVar += "                          <strong>";
              strVar += "                         "+editNoteTitle;
              strVar += "                          <\/strong>";
              strVar += "                        <\/div>";
              strVar += "                        <div class=\"note-subject\">";
              strVar += "                         "+editNoteSubject;
              strVar += "                        <\/div>";
              strVar += "                        <span class=\"text-xs text-muted\"><\/span>";
              strVar += "                      <\/div>";
              strVar += "                      <div hidden class='storageIndex'>"+idd+"</div>";
              note.html(strVar);
              if(localStorage["notes-app-"+idd]){               //model
                var noteObject = JSON.parse(localStorage["notes-app-"+idd]); //model
                noteObject.title   = editNoteTitle;
                noteObject.subject = editNoteSubject;
                localStorage["notes-app-"+idd] = JSON.stringify(noteObject); //model
                $('#note-title').text(noteObject.title);          //view
                $('#note-text-area').val(noteObject.description); //view
                $.ajax({
                  url: protocol + '//' + domain + '/' + route + '/' + editNoteTitle,
                  type: "PATCH",
                  data: { resource: { title: editNoteTitle, description: noteObject.description, subject: editNoteSubject } }
                }).done(function (response){
                  if(response.success){
                    $('.bb-alert').delay(200).fadeIn().delay(4000).fadeOut(); //dom-view
                  }
                  else{
                    $('.bb-alert-fail').delay(200).fadeIn().delay(4000).fadeOut(); //dom-view
                  }
                })
              }
            }
        }
      }
    })
    //"Title name:", function (result) {
     //});//end bootbox

  });//end on dblcick
}

$(document).on('ready',function(){
  reIndexModels()
  createNoteListener();
  updateNoteContentListener();
  var noteContainer = $('#note-items');
  editNoteListener(noteContainer);    //controller-view
  sessionStorage.loggedInStatus = ( $('#user-username').attr('style').split(':')[1] !== " red;" ) //controller
});//end document ready


//Procedure
//{"id":1,"name":"my note title","description":"blablabala ","user":"Anon"}
//1. when text area changes, the description must be updated, this requires a json parse and re-stringify
//   a. text area changes
//   b. grab its value
//   c. json parse the local storage object to reform it from string
//   d. update the description key/value
//   e. json stringify the object and reset the key in the local storage with the updated string value
//
//notes-app-n => Key to object in localStorage

//Constructed a json tree object server side f
