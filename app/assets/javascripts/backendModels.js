function CategoryModel(name, description, parent_name){
  this.category = { name: name, description: description};
  this.parent_category = parent_name;
}
window.category = {};
window.category.contructor = CategoryModel;
function ResourceModel(title,description,parent_name){
  this.resource = {title: title, description: description, file: "optional"};
  this.parent = parent_name;
}
window.resource = {};
window.resource.contructor = ResourceModel;

var locationArray = window.location.href.split('/');
var PROTOCOL      = locationArray[0];
var DOMAIN        = locationArray[2];
var ROUTE;

//data: new ResourceModel("jimmy","note contents","bean")

function setAjaxCall(noteObject,data){
    data = (data || {});
    var url,type;
    //wich rails controller are we hitting? //controller-parameters
    if(noteObject.route){
        ROUTE = noteObject.route;
    }
    else{
      ROUTE = "resource";
    }
    //create or update?  //contorller-parameters
    if(noteObject.id){ //update code
       url  = PROTOCOL + '//' + DOMAIN + '/' + ROUTE + '/' + noteObject.id;
       type = "PATCH";
    }
    else{
       url  = PROTOCOL + '//' + DOMAIN + '/' + ROUTE;
       type = "POST";
    }
    var ajaxObject = { url: url, type: type, data: data};
    return ajaxObject;
}