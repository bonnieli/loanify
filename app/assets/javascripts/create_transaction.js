var users_selected = {};
var transaction_date = $(".datepicker").datepicker({

}).on('changeDate', function(ev) {
	transaction_date.hide(); // hide on page load 
}).data('datepicker');


var substringMatcher = function(strs) {
  return function findMatches(q, cb) {
    var matches, substringRegex;
 
    // an array that will be populated with substring matches
    matches = [];
 
    // regex used to determine if a string contains the substring `q`
    substrRegex = new RegExp(q, 'i');
 
    // iterate through the pool of strings and for any string that
    // contains the substring `q`, add it to the `matches` array
    $.each(strs, function(i, str) {
      if (substrRegex.test(str.first_name + ' ' + str.last_name)) {
        // the typeahead jQuery plugin expects suggestions to a
        // JavaScript object, refer to typeahead docs for more info
        matches.push({ value: str, full_name: str.first_name + ' ' + str.last_name, id: str.id, profile_picture: str.profile_picture, email_address: str.email_address});
      }
    });
 
    cb(matches);
  };
};
 

$(' .typeahead').typeahead({
  hint: true,
  highlight: true,
  minLength: 1
},
{
  name: 'all_users',
  displayKey: 'full_name',
  source: substringMatcher(all_users),
  templates: {
  	empty: [
  		'sorry nothing available'
  	].join('\n'),
  	suggestion: Handlebars.compile('<img class="profile_pic" src="{{ profile_picture }}">{{ full_name }}')
  }
}).on("typeahead:selected", function(e, suggestion, name){
  $(".typeahead").val('');
  if (!users_selected[suggestion.id]) {
    users_selected[suggestion.id] = suggestion;
    build_selected_user(suggestion);
  }
});

$(".typeahead").focus(function() {
    // console.log('in');
}).blur(function() {
  $(this).val('');
});

function build_selected_user(suggestion) {
  var str = '<div class="selected_user_container">';
  str += '<img src="' + suggestion.profile_picture + '" width="30px">';
  str += '<div class="selected_user_content">'+ suggestion.full_name + '</div>';
  str += '<div class="selected_user_delete" data-id=' + suggestion.id + '>';
  str += '<i class="fa fa-times"></i></div>';
  str += '</div>';
  $("#selected_users").append(str);
}

$("#selected_users").on('click', '.selected_user_delete', function() {
  var id = parseInt($(this).data('id'));
  delete users_selected[id];
  $(this).parent().remove();
});

$("#create_transaction").validate({
  rules: {
    // compound rule
    Amount: {
      required: true,
      number: true
    },
    Date: "required",
    Description: {
    	maxlength: 255
    }
  },
  submitHandler: function(form, event) {
    // event.preventDefault();
  	var data = { "BorrowerKey": users_selected,
								"Amount": $("input[name=Amount]").val(),
								"Date": $("input[name=Date]").val(),
								"Description": $("input[name=Description]").val() }
		$.ajax({
		  type: "POST",
		  url: "/transaction/post",
		  dataType: 'json',
		  data: data,
		  success: function(data) {
		  	console.log('SUCCESS');
        $("#selected_users").hide();
		  	$("#create_transaction").slideUp( function() {
		  		$("#success").slideDown();
		  	});
		  }, 
		  error: function(data) {
		  	alert('An error has occured');
		  }
		});
		return false;
  }
});