class Teilnahme 

	include Comparable

  	@@OFFEN = 1
	@@BESTAETIGT = 2
	@@ABGELEHNT = 3	

	attr_reader :teilnehmer, :status

	def Teilnahme::new_default(teilnehmer)
		Teilnahme.new(@@OFFEN, teilnehmer)
	end

	def initialize(status, teilnehmer)
		@status = status
		@teilnehmer = teilnehmer
	end

	def <=> (obj)
		@teilnehmer <=>  obj.teilnehmer
	end

	def hash 
		@teilnehmer.hash
	end
	
	
	def == (obj) 
		@teilnehmer == obj.teilnehmer
	end

	def bestaetige
		@status = @@BESTAETIGT
	end

	def lehne_ab
		@status = @@ABGELEHNT
	end

	def ist_abgelehnt
		@status == @@ABGELEHNT
	end

	def Teilnahme::BESTAETIGT
		@@BESTAETIGT
	end


	def Teilnahme::OFFEN
		@@OFFEN
	end

	def Teilnahme::ABGELEHNT
		@@ABGELEHNT
	end

end

