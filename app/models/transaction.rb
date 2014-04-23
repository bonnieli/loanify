class Transaction < ActiveRecord::Base
	
	def self.newtransaction(input) #new transaction
		transaction = Transaction.new
		transaction.transaction_date = input["transaction_date"]
		transaction.description = input["description"]
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
		return (Transaction.where({id_b: input["id"], paidback: true})).to_json
	end

	def self.borrower_rejected(input)
		return (Transaction.where({id_b: input["id"], rejected: true})).to_json
	end

	def self.borrower_unpaid(input)
		return (Transaction.where({id_b: input["id"], paidback: false, reject: false})).to_json
	end

#split for lenders
	def self.lender_paidback(input)
		return (Transaction.where({id_l: input["id"], paidback: true})).to_json
	end

	def self.lender_rejected(input)
		return (Transaction.where({id_l: input["id"], rejected: true})).to_json
	end

	def self.lender_unpaid(input)
		return (Transaction.where({id_l: input["id"], paidback: false, reject: false})).to_json
	end

#graphs

#HISTORY GRAPH
	def self.historygraph(input)
		result = []
		start = Date.today - 7
		for i in (0..7)
			current = start + i
			item = OpenStruct.new
			item.l_amount = (Transaction.where("id_b = ? AND reject = ? AND transaction_date <= ? AND 
				(paidback = ? OR date_paidback > ?)", input, false, current, false, current).pluck("SUM(amount) as amount"))[0]
			item.b_amount = (Transaction.where("id_l = ? AND reject = ? AND transaction_date <= ? AND 
				(paidback = ? OR date_paidback > ?)", input, false, current, false, current).pluck("SUM(amount) as amount"))[0]
			if item.l_amount == nil
				item.l_amount = 0
			end
			if item.b_amount == nil
				item.b_amount = 0
			end
			item.date = current
			result.push(item)
		end
		return result.to_json

	end


#PIE CHARTS
	def self.borrower_piechart(input) #input needs to be ID, check all IOUs
		result = Transaction.find_by_sql("Select id_l, SUM(amount) as amount FROM Transactions WHERE id_b = '#{input}' GROUP BY id_l")
		return result.to_json
	end

	def self.lender_piechart(input) #input needs to be ID, check all UOIs
		result = Transaction.find_by_sql("Select id_b, SUM(amount) as amount FROM Transactions WHERE id_l = '#{input}' GROUP BY id_b")
		return result.to_json
	end

end