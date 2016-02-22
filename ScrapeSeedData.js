function scrapeTree(options,$){
  var protocol = options.protocol || 'http:' ;
  var domain   = options.domain   || 'localhost:3000';
  var route    = options.route; //required
  var tree     = options.tree;
  var url      =  protocol + '//' + domain + '/' + route;

  var current  = tree;

  function recurseTree(current_node,parent_id){
     //1. save node to database belonging to parent
     //2. wait for reponse with current node's id
     //3. recurse children
     var data = { category: {name: current_node.name}, parent_id: parent_id };
     var request = $.ajax({
        url   : url,
        method: "POST",
        data  : data
     });//end ajax req
     request.done(function (response, textStatus, xhr){
        //if(xhr.status === 204){//did the last node save properly
          console.log("saved");
          console.log(response);
          var parent_id = response.id; //id of current_node that was just saved
          if( Array.isArray(current_node.children) ){
            current_node.children.forEach(function (node){
              recurseTree(node, parent_id);
            });//forEach
          }
          else{
            return;
          }
        //}
     });//req.done

     request.fail(function (error){
        console.log(error);
     });//req.fail
  }//end recurseTree

  recurseTree(current);
}//end scrapeTree
