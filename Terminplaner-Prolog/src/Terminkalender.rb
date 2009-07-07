require "Termin"

class Terminkalender

	def initialize(repository, besitzer)
		@repository = repository
		@besitzer = besitzer
	end
	
	def new_termin(jetzt, dauer_in_minuten, bezeichnung) 
		termin = Termin.new(@besitzer, jetzt, dauer_in_minuten, bezeichnung)
		@repository.speichere termin
		termin
	end

	def hat_termin(termin)
		@repository.hat_termin termin 
	end

	def alle_termine
		termine false
	end
	
	def termine(zeige_auch_abgelehnte)
		@repository.termine(@besitzer, zeige_auch_abgelehnte)
	end

end

