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
		@termine.inject([]) { |result, termin|
			termin.fuege_zu_terminliste_hinzu(result, besitzer, zeige_auch_abgelehnte)  # TDA: Tell, don't ask
			result
		}.sort
	end
		
end
