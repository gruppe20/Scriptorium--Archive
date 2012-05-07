// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
	$.ajax({
		type: "POST",
		url: "/ajax/get_series",
		data: "fond_id=66b2ed65-901c-437d-9d72-564dd00b3ef1"
	}).done(function(data) {
		for(var i=0; i < data.length; i++)
			$("#students").append("<option value=\""+data[i]["system_id"]+"\" >"+data[i]["title"]+"</option>");
	});
	
	$(document).off('click', '#students');
	$(document).on('click', '#students', function(e) {
		$(this).attr("value");
	});
});