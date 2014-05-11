	var nowTemp = new Date();
	var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

	var transaction_date = $(".datepicker").datepicker({
		onRender: function(date) {
			return date.valueOf() < now.valueOf() ? 'disabled' : ''; // disables any dates before today
		}
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
	}).on("typeahead:selected typeahead:autocompleted", function(e, suggestion, name){
		document.getElementById("create_transaction").elements["BorrowerKey"].value = suggestion.id;
		document.getElementById("create_transaction").elements["B_Picture"].value = suggestion.profile_picture;
		document.getElementById("create_transaction").elements["BorrowerEmail"].value = suggestion.email_address;
	});

	$("#Amount").on("keyup", function(){
    var valid = /^\d{0,4}(\.\d{0,2})?$/.test(this.value),
      val = this.value;    
    if(!valid){
      this.value = val.substring(0, val.length - 1);
    }
	});

	$("#create_transaction").validate({
	  rules: {
	    // simple rule, converted to {required:true}
	    Name: "required",
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
	  submitHandler: function(form) {
	  	var data = { "BorrowerKey": $("input[name=BorrowerKey]").val(),
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