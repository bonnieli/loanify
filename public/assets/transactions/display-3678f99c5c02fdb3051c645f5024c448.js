$(document).ready(function () {
    $(".reject-confirm").click( function() {
    	var t = $(this);
    	vex.dialog.prompt({
			message: 'Are you sure you want to reject this transaction?',
			placeholder: 'Reject reason',
			callback: function(value) {
				if (value) {
					var data = {"id": t.data("id"),
								"reject_reason": value}
					$.ajax({
						type: "POST",
						url: "/transaction/reject",
						dataType: 'json',
						data: data,
						success: function(data) {
							location.reload();
						}, 
						error: function(data) {
							alert('An error has occured');
						}
					});
				}
			}
		});
    })
    $(".delete-confirm").click( function() {
    	var t = $(this);
    	vex.dialog.confirm({
			message: 'Are you sure you want to delete this transaction?',
			callback: function(value) {
				if (value) {
					window.location.replace("/welcome/delete_transaction/" + t.data("id"));
				}
			}
		});
	});

    var date_pickers = $('.pb-date').datepicker({
	    onRender: function(date) {
	   		return date.valueOf() < now.valueOf() ? 'disabled' : ''; // disables any dates before today
    	}
    }).on('changeDate', function(ev){
	    $(this).datepicker('hide');
	    var date = $(this).val();
	    var t = $(this);
	    vex.dialog.open({
			message: 'Are you sure you want to select paidback date as ' + date + '?',
			callback: function(value) {
				if (value) {
					var data = {"id": t.data("id"),
								"datepaidback": date}
					$.ajax({
						type: "POST",
						url: "/transaction/paidback",
						dataType: 'json',
						data: data,
						success: function(data) {
							if (data.status == 500) {
								vex.dialog.alert('Error - You have selected a date earlier than the transaction.')
							} else if (data.status == 200) {
								location.reload();
							}
						}, 
						error: function(data) {
							alert('An error has occured');
						}
					});
				}
			}
		});
	}).data('datepicker');
});
