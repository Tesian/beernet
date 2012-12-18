$(document).ready(function(){

    if ($("#todo_wrapper"))
    {
	var data;
        $.ajax({
	    url: "http://" + window.location.hostname + "/todos?todo_list_id=" + window.location.href.split("/")[6],
            dataType: 'json',
	    data: data,
            success: function(data){
		for(var i= 0; i < data.length; i++)
		{
		    add_todo(data[i]);
		}
		$(".delete_todo").click(function(e) {
		    e.preventDefault();
		    var link_delete = $(this)
		    $.ajax({
			type: "DELETE",
			url: "http://" + window.location.hostname + "/todos/" + $(this).data("id"),
			data: data,
			success: function(data){
			    link_delete.parent().remove();
			}
		    });
		});
	    }
	});
    }

    // don't work when click nothing happens
    $("#add_todo").click(function(e){
	e.preventDefault();

	var data = "body=" + $("#new_todo").attr("value") + "&todo_list_id=" + window.location.href.split("/")[6];
        $.ajax({
	    type: "POST",
	    url: "http://" + window.location.hostname + "/todos",
            data: data,
            success: function(data){
		add_todo(data);
	    }
	});
    });

    function add_todo(data){
	var todo = document.createElement("div");
	todo.innerHTML = data["body"] + " ";
	document.getElementById('todo_wrapper').insertBefore(todo, document.getElementById('new_todo'));
	var delete_todo = document.createElement("a")
	delete_todo.setAttribute("href", "");
	delete_todo.setAttribute("class", "delete_todo");
	delete_todo.setAttribute("data-id", data["id"]);
	delete_todo.innerHTML = "X";
	todo.appendChild(delete_todo);
    }
})