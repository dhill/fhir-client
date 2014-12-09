class Patient

  def name
    [ patient["familyName"], patient["givenName"] ].join(', ')
  end

  #-------------------------------------------------------------------------------

  def self.parse_from_fhir(fhir)
    patients = []

    fhir["entry"].map do |resource|
      patient = Hash.new

      Rails.logger.debug "--------- resource['content'] = #{resource["content"]} ----------"
      Rails.logger.debug "--------- resource['entry'] = #{resource["entry"]} ----------"
      
      patient["familyName"]   = resource["content"]["name"].first["family"]
      patient["givenName"]    = resource["content"]["name"].first["given"]
      patient["birthDate"]    = Date.parse(resource["content"]["birthDate"])
      patient["id"]           = resource["entry"]["id"]

      patients << patient
    end

    patients
  end
  
end
