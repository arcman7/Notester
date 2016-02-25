function CategoryModel(name, description, parent_name){
  this.category = { name: name, description: description};
  this.parent_category = parent_name;
}

function ResourceModel(title,description,parent_name){
  this.resource = {title: title, description: description, file: "optional"};
  this.parent = parent_name;
}


//data: new ResourceModel("jimmy","note contents","bean")
