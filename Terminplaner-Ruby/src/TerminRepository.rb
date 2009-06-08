require "set"

class TerminRepository 

	def initialize
		@termine =  Set.new
	end
	
	def speichere(termin)
		@termine << termin		
	end

	def hat_termin(termin)
		@termine.include? termin
	end

	def termine(besitzer, zeige_auch_abgelehnte)
		@termine.find_all { |termin| termin.sichtbar?(besitzer, zeige_auch_abgelehnte) }.sort
	end
		
end
