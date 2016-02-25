+function ($) {

  $(function(){

    var intro = introJs();

    intro.setOptions({
      steps: [
       {
          element: '#tree-list',
          intro: '<h1 style="font-size: 100px">Welcome to Notester!!</h1>',
          position: 'right'
        },
      {
          element: '#note-detail',
          intro: '<p class="h4 text-uc"><strong>1: Take Notes!!</strong></p><p>Make sure to write a note to save for later!</p>',
          position: 'left'
        },
        {
          element: '#new-note',
          intro: '<p class="h4 text-uc"><strong>2: Start a new note </strong></p><p>Press this button to start a new note.</p>',
          position: 'left'
        },
        {
          element: '#save-note',
          intro: '<p class="h4 text-uc"><strong>3: Save the note</strong></p><p>Press this button to save your note.</p>',
          position: 'left'
        },
        {
          element: '#note-list',
          intro: '<p class="h4 text-uc"><strong>4: Recent Notes</strong></p><p>See your recent notes being displayed.</p>',
          position: 'left'
        },
        {
          element: '#tree-list',
          intro: '<p class="h4 text-uc"><strong>5: Note Tree</strong></p><p>Click on a note to see what others are saying!</p>',
          position: 'right'
        }
      ],
      showBullets: true,
    });

    checkLocalStorage(intro);

  });
}(jQuery);


function checkLocalStorage(introFunc){
  if(typeof(Storage) !== "undefined") {
    checkForUserHistory(introFunc);
  } else {
      // Sorry! No Web Storage support..
      alert("Sorry! Your broswer does not support storage. Please use chrome, firefox or safari in order to get the full experiece of Notester.");
  }
}

function checkForUserHistory(introFunc){
  if(localStorage.notesterUser){
    //code for returning user
    $('#user-username').text(localStorage.notesterUser)
  }else{
    introFunc.start();
    localStorage.notesterUser = "Anon";
  }
}
