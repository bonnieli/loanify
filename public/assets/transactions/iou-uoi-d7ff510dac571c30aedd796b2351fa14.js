$(document).ready( function() {
	$(".transaction_container li").click( function() {
		window.location.href = "/transaction/" + $(this).data("id");
	});
});
