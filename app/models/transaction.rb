class Transaction < ActiveRecord::Base
	
	def self.newtransaction(input) #new transaction
		transaction = Transaction.new
		transaction.paidback = false
		transaction.reject = false
		transaction.id_b = input["borrower_key"]
		transaction.id_l = input["lender_key"]
		transaction.amount = input["amount"]
	    transaction.b_email = User.find(input["borrower_key"]).email_address
	    transaction.l_email = User.find(input["lender_key"]).email_address
		transaction.save
		return transaction
	end

	def self.paidback(input) #payback a transaction
		transaction = Transaction.find(input["id"])
		transaction.paidback = true
		if transaction.transaction_date > input["datepaidback"]
			return false
		end
		transaction.datepaidback = input["datepaidback"]
		transaction.paidback_time = (transaction.datepaidback - transaction.transaction_date).to_i
		return transaction.b_email
	end

	def self.reject(input) #reject a transaction
		transaction = Transaction.find(input["id"])
		transaction.reject = true
		transaction.reject_date = Date.today
		transaction.reject_reason = input["reject_reason"]
		return transaction.l_email
	end

	def self.deletetransaction(input)
		Transaction.destroy(input)
	end

#End of all insert/updates/deletes

###############################################################################################################
###############################################################################################################
###############################################################################################################
###############################################################################################################
###############################################################################################################

#split for borrowers
	def self.borrower_paidback(input)
		return Transaction.where({id_b: input["id"], paidback: true})
	end

	def self.borrower_rejected(input)
		return Transaction.where({id_b: input["id"], rejected: true})
	end

	def self.borrower_unpaid(input)
		return Transaction.where({id_b: input["id"], paidback: false, reject: false})
	end

#split for lenders
	def self.lender_paidback(input)
		return Transaction.where({id_l: input["id"], paidback: true})
	end

	def self.lender_rejected(input)
		return Transaction.where({id_l: input["id"], rejected: true})
	end

	def self.lender_unpaid(input)
		return Transaction.where({id_l: input["id"], paidback: false, reject: false})
	end

#graphs
	def self.historygraph(input)

	end

	def self.piechart(input)
	
	end

end