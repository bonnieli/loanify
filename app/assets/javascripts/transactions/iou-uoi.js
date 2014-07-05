$(document).ready( function() {
	// $(".transaction_container li").click( function() {
	// 	window.location.href = "/transaction/" + $(this).data("id");
	// });
	var box = {
		lender : $('.lender'),
		borrower: $('.borrower'),
		l_fullname: $('.l_fullname'),
		b_fullname: $('.b_fullname'),
		amount: $('.amount'),
		status: $('.status')
	};
	$(".transaction_container li").click( function() {
		var id = $(this).data("id");
		$.ajax({
			type: "GET",
			url: "/" + id,
			dataType: 'json',
			success: function(data) {
				console.log(data);
				var lender = data.id_l;
				var borrower = data.id_b;
				box["lender"].attr('src', data.pic_l);
				box["borrower"].attr('src', data.pic_b);

				box["l_fullname"].text(data.fn_l);
				box["b_fullname"].text(data.fn_b);
				box["amount"].text('$' + data.amount);

				if (data.paidback) {
					box["status"].html("Paidback on " + data.transaction_date);
				} else if (data.reject) {
					box["status"].html("Rejected on " + data.transaction_date);
				}
			}, 
			error: function(data) {
				alert('An error has occured');
			}
		});
	});

});