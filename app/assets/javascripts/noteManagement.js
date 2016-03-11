window.notesterGLOBALS = {};

localStorage["notes-app"] = ""; //controller
var storageKeys  = []; //GLOBAL //controller-params

function setKeys(){
  for(var i=33; i<127; i++){
    storageKeys.push( String.fromCharCode(i) );
  }
}
setKeys();                       //controller
var storageIndex = 0;            //controller

var ROUTE = "resource";

function id(){ return storageKeys[storageIndex] };
function htmlTemplate(idd,title,subject){ //view
  title   = (title || "Note Title");
  subject = (subject || "Subject");
  var idd =  ( idd || id() );
  strVar = ""
  strVar += "<li class=\"list-group-item hover active\" >";
  strVar += "                      <div class=\"view\">";
  strVar += "                        <button class=\"destroy close hover-action\">×<\/button>";
  strVar += "                        <div class=\"note-name\">";
  strVar += "                          <strong>";
  strVar += "                            "+title;
  strVar += "                          <\/strong>";
  strVar += "                        <\/div>";
  strVar += "                        <div class=\"note-subject\">";
  strVar += "                          "+subject;
  strVar += "                        <\/div>";
  strVar += "                        <span class=\"text-xs text-muted\"><\/span>";
  strVar += "                      <\/div>";
  strVar += "                      <div hidden class='storageIndex'>"+idd+"</div>";
  strVar += "                    <\/li>";
  return strVar;
}

function getd3NoteParams(){
  var title       = $('#note-title').text();
  var description = $('#note-text-area').val();
  var subject     = sessionStorage.notesterNodeParent;
  return {title: title, subject: subject, description: description};
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

function addNote(id,newNote){             //view, mixed with d3-node handling
  var noteContainer = $('#note-items');
  //console.log("noteContainer: ",noteContainer)
  if(id){
    //storageIndex = //what was this for?
    var subject,title;
    if(newNote){ //handles creating a new note for node in focus //model mixed with d3 behavior
      //model-d3
      var noteParams = getd3NoteParams();
      var note = new Note(localStorage.notesterUser, noteParams.title, noteParams.subject,noteParams.description); //model
      /////////////// D3 specific behavior //////////////
      note.route = "category";

      localStorage['notes-app-'+id] = JSON.stringify(note);
      subject = noteParams.subject; title = noteParams.title
      //what do i do with this? call htmlTemplate(id,title,subject)
    }
    else{
      var noteObject = JSON.parse( localStorage['notes-app-'+id] );
      subject = noteObject.subject; title = noteObject.title;
    }
    noteContainer.append(htmlTemplate(id,title,subject));
    return;
  }
                //controller
  var note = new Note(localStorage.notesterUser, "title","subject","blank");

  noteContainer.append(htmlTemplate());  //view

  //console.log(JSON.stringify(note))
  $('#note-text-area').val(note.description); //view
  $('#note-title').text(noteObject.title);    //view
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
    sessionStorage.notesterIdFocus = storageId;  //model
    $('.active').removeClass('active');          //view
    $(this).addClass('active');                  //view
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
      console.log(" NO pre-existing note?: ",!localStorage["notes-app-"+storageId])
      if(!localStorage["notes-app-"+storageId] ){
        addNote(storageId,true);        //view  //makes unique ids for node-note objects
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
    if(key.includes('notes-app-')){
        var id = key.split('-')[2];
        console.log("reIndexModels id: ",id)
        if(id > 1){ //doesnt mess with node noteObjects
          newKey   = storageKeys[counter]; //model
          newValueCopy = localStorage[key]; //if the set of noteobjects and keys have no holes, then newKey and key are equivalent// also, model
          delete localStorage[key];
          localStorage["notes-app-" + newKey] = newValueCopy;
          addNote(newKey);
          console.log("key: ", newKey);
          counter++;
        }
        else{
          addNote(id); //add in node-note object mdodel to the dom (right hand side)
        }
    }
 }//end for
$('.active').removeClass('active'); //view

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
              // var strVar = "";
              // strVar += "                      <div class=\"view\">";
              // strVar += "                        <button class=\"destroy close hover-action\">×<\/button>";
              // strVar += "                        <div class=\"note-name\">";
              // strVar += "                          <strong>";
              // strVar += "                         "+editNoteTitle;
              // strVar += "                          <\/strong>";
              // strVar += "                        <\/div>";
              // strVar += "                        <div class=\"note-subject\">";
              // strVar += "                         "+editNoteSubject;
              // strVar += "                        <\/div>";
              // strVar += "                        <span class=\"text-xs text-muted\"><\/span>";
              // strVar += "                      <\/div>";
              // strVar += "                      <div hidden class='storageIndex'>"+idd+"</div>";
              htmlTemplate(idd, editNoteTitle, editNoteSubject);
              note.html(strVar);
              if(localStorage["notes-app-"+idd]){//is it in local storage?   //model
                var noteObject = JSON.parse(localStorage["notes-app-"+idd]); //model
                //var url,type//,route; //handles creation vs updates of noteObjects
                setUrl(noteObject); // controller

                noteObject.title   = editNoteTitle;
                noteObject.subject = editNoteSubject;
                localStorage["notes-app-"+idd] = JSON.stringify(noteObject); //model
                $('#note-title').text(noteObject.title);          //view
                $('#note-text-area').val(noteObject.description); //view
                // $.ajax({
                //   //url: protocol + '//' + DOMAIN + '/' + route + '/' + editNoteTitle,
                //   url: url,
                //   type: type,
                //   data: { resource: { title: editNoteTitle, description: noteObject.description, subject: editNoteSubject } }
                // })
                var data = { resource: { title: editNoteTitle, description: noteObject.description, subject: editNoteSubject} };
                var request = setAjaxCall(noteObject, data);
                request.done(function (response){
                  console.log(response);
                  if(response.success){
                    $('.bb-alert').delay(200).fadeIn().delay(4000).fadeOut(); //dom-view
                  }
                  else{
                    $('.bb-alert-fail').delay(200).fadeIn().delay(4000).fadeOut(); //dom-view
                  }
                })
              }//if note object exsists in local storage (should already)
            }//end callback
        }
      }
    })
    //"Title name:", function (result) {
     //});//end bootbox

  });//end on dblcick
}

function noteBehaviorController(){
  var noteContainer = $('#note-items');
  sessionStorage.loggedInStatus = ( $('#user-username').attr('style').split(':')[1] !== " red;" ) //controller
  reIndexModels(); //model management
  destroyNoteListener(noteContainer); //controller-view
  bindFocus(noteContainer);    //controller-view behavior
  createNoteListener();        //controller-view behavior
  updateNoteContentListener(); //controller-view-model behavior
  editNoteListener(noteContainer);    //controller-view
}


$(document).on('ready',function(){
  noteBehaviorController();
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
