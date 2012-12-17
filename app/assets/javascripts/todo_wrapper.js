$(document).ready(function(){

    if ($("#todo_wrapper"))
    {
	var data;
        $.ajax({
	    url: "http://" + window.location.hostname + ":3000" + "/todos?todo_list_id=" + window.location.href.split("/")[6],
            dataType: 'json',
	    data: data,
            success: function(data){
		for(var i= 0; i < data.length; i++)
		{
		    var todo = document.createElement("div");
		    todo.setAttribute("data-id", data[i]["id"]);
		    todo.innerHTML = data[i]["body"];
		    document.getElementById('todo_wrapper').appendChild(todo);
		}
		my_input  = document.createElement("input");
		my_input.setAttribute("id", "new_todo");
		document.getElementById('todo_wrapper').appendChild(my_input);

		my_button = document.createElement("button");
		my_button.setAttribute("id", "add_todo");
		my_button.innerHTML = "add todo";
		document.getElementById('todo_wrapper').appendChild(my_button);
	    }
	});
    }

    // don't work when click nothing happens
    $("button#add_todo").click(function(e){
	e.preventDefault();

	var data = "body" + $("#new_todo").attr("value") + "&todo_list_id=" + window.location.href.split("/")[6];
        $.ajax({
	    type: "POST",
	    url: "http://" + window.location.hostname + ":3000" + "/todos",
            data: data,
            success: function(data){
		var todo = document.createElement("div");
		todo.setAttribute("data-id", data[i]["id"]);
		todo.innerHTML = data[i]["body"];
		document.getElementById('todo_wrapper').appendChild(todo);
	    }
	});
    });
})