require "Teilnahme"

class Termin 

	include Comparable

	attr_reader :bezeichnung, :autor, :start_zeit, :dauer_in_minuten, :teilnahmen

	def initialize(autor, start_zeit, dauer_in_minuten, bezeichnung)
		@autor = autor
		@start_zeit = start_zeit
		@dauer_in_minuten = dauer_in_minuten
		@bezeichnung = bezeichnung
		@teilnahmen = Set.new
		@teilnahmen.add( Teilnahme.new(Teilnahme::BESTAETIGT, autor) )
	end

	def <=> (obj)
		start_zeit_compare = @start_zeit <=> obj.start_zeit

		if start_zeit_compare == 0 then to_s <=> obj.to_s else start_zeit_compare end

		start_zeit_compare
	end

	def to_s 
		"#{start_zeit}: #{bezeichnung} (#{dauer_in_minuten} Min.)"
	end

	def lade_teilnehmer_ein(einTeilnehmer) 
		@teilnahmen.add( Teilnahme.new_default(einTeilnehmer) )
	end

	def teilnehmer
		result = []
		@teilnahmen.each { |teilnahme|
		  	result << teilnahme.teilnehmer
	    	}
		result.sort
	end

	def teilnahme_status(benutzer)
		teilnahme(benutzer).status
	end

	def bestaetige_termin(benutzer)
		teilnahme(benutzer).bestaetige
	end

	def lehne_termin_ab(benutzer)
		teilnahme(benutzer).lehne_ab
	end

	def fuege_zu_terminliste_hinzu(terminliste, benutzer, zeige_auch_abgelehnte)
		benutzer_ok = benutzer == autor || ist_eingeladen?(benutzer)
		if benutzer_ok and (zeige_auch_abgelehnte or ist_teilnahme_noch_moeglich?(benutzer))
			terminliste << self 
		end
	end

	def teilnahme(benutzer)
		result = nil
		teilnahmen.each { |teilnahme|
			if benutzer == teilnahme.teilnehmer
				return result = teilnahme
		    	end
		}
		raise BenutzerNichtEingeladenException.new
	end

	def ist_teilnahme_noch_moeglich?(benutzer)
		return ist_eingeladen?(benutzer) && !teilnahme(benutzer).ist_abgelehnt
	end

	def ist_eingeladen?(benutzer) 
		begin
			teilnahme(benutzer)
			return true
		rescue BenutzerNichtEingeladenException
			return false
		end
	end

end

