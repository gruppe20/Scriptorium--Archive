require "savon"
require "base64"

module Archive
  class SOAP
    def initialize
      @@client = Savon::Client.new("http://ark1.hio.no/n5/Noark5BaseService3?wsdl")
      @@fondUUID = "66b2ed65-901c-437d-9d72-564dd00b3ef1" # Scriptorium
     # @@seriesUUID = "a290da90-a312-47ca-8c65-8505cd46bb64" # test
    end
    
    def get_fonds_series
      result = @@client.request :ser, :fonds_get_series, body: @@fondUUID
      data = result.to_hash[:fonds_get_series_response][:item]
    end
    
    def get_specific_series(title)
      data = get_fonds_series
      data.each do |s|
        if s[:title] == title
          return s
        end
      end
    end
    
    def get_specific_series_uuid(title)
      series = get_specific_series(title)
      series[:system_id]
    end
    
    def create_file(series, title, officialTitle, desc, docMedium, createdBy)
      parent_id = get_specific_series_uuid(series)
      result =  @@client.request :ser, :case_create_file do |soap|
                  soap.xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service3.base.module.n5ic/\">
                     <soapenv:Header/>
                     <soapenv:Body>
                        <ser:seriesSystemId>"+parent_id+"</ser:seriesSystemId>
                        <ser:parentFileSystemId></ser:parentFileSystemId>
                        <ser:title>"+title+"</ser:title>
                        <ser:officialTitle>"+officialTitle+"</ser:officialTitle>
                        <ser:description>"+desc+"</ser:description>
                        <ser:documentMedium>"+docMedium+"</ser:documentMedium>
                        <ser:createdBy>"+createdBy+"</ser:createdBy>
                     </soapenv:Body>
                  </soapenv:Envelope>"
                end
        result.to_hash[:case_file_create_response][:message]
    end
    
    def create_child_file(parent_id, title, officialTitle, desc, docMedium, createdBy)
      result =  @@client.request :ser, :case_create_file do |soap|
                  soap.xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service3.base.module.n5ic/\">
                     <soapenv:Header/>
                     <soapenv:Body>
                        <ser:seriesSystemId></ser:seriesSystemId>
                        <ser:parentFileSystemId>"+parent_id+"</ser:parentFileSystemId>
                        <ser:title>"+title+"</ser:title>
                        <ser:officialTitle>"+officialTitle+"</ser:officialTitle>
                        <ser:description>"+desc+"</ser:description>
                        <ser:documentMedium>"+docMedium+"</ser:documentMedium>
                        <ser:createdBy>"+createdBy+"</ser:createdBy>
                     </soapenv:Body>
                  </soapenv:Envelope>"
                end
      result.to_hash
    end
    
    def create_record(parent_id, title, officialTitle, desc, docMedium, createdBy)
      result =    @@client.request :ser, :registry_entry_create do |soap|
                    soap.xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service3.base.module.n5ic/\">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <ser:caseFileSystemId>"+parent_id+"</ser:caseFileSystemId>
                          <ser:title>"+title+"</ser:title>
                          <ser:officialTitle>"+officialTitle+"</ser:officialTitle>
                          <ser:description>"+desc+"</ser:description>
                          <ser:documentMedium>"+docMedium+"</ser:documentMedium>
                          <ser:createdBy>"+createdBy+"</ser:createdBy>
                       </soapenv:Body>
                    </soapenv:Envelope>"
                  end
        result.to_hash
    end
    
    def create_file(parent_id, document_type, title, description, created_by, file)
      result =    @@client.request :ser, :document_create do |soap|
                    soap.xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service3.base.module.n5ic/\">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <ser:reSystemId>"+parent_id+"</ser:reSystemId>
                          <ser:documentType>"+document_type+"</ser:documentType>
                          <ser:title>"+title+"</ser:title>
                          <ser:description>"+description+"</ser:description>
                          <ser:createdBy>"+created_by+"</ser:createdBy>
                          <ser:documentMedium>electronic archive</ser:documentMedium>
                          <ser:base64Content>"+Base64.encode64(open(file).to_a.join)+"</ser:base64Content>
                          <ser:extension>"+File.extname(file).gsub(".","")+"</ser:extension>
                          <ser:format>"+File.extname(file).gsub(".","")+"</ser:format>
                       </soapenv:Body>
                    </soapenv:Envelope>"
                  end
      result.to_hash
    end
    
    def get_file_info(file_id)
      result =    @@client.request :ser, :document_description_get_document_objects do |soap|
                    soap.xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service3.base.module.n5ic/\">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <ser:documentDescriptionGetDocumentObjects>"+file_id+"</ser:documentDescriptionGetDocumentObjects>
                       </soapenv:Body>
                    </soapenv:Envelope>"
                  end
      result_hash = result.to_hash[:document_description_get_document_objects_response][:item]
                  
      extra =     @@client.request :ser, :document_object_get_document_description do |soap|
                    soap.xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service3.base.module.n5ic/\">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <ser:documentObjectGetDocumentDescription>"+result_hash[:system_id]+"</ser:documentObjectGetDocumentDescription>
                       </soapenv:Body>
                    </soapenv:Envelope>"
                  end
      extra_hash = extra.to_hash[:document_object_get_document_description_response]
      result_hash[:"title"] = extra_hash[:title]
      result_hash[:"document_type"] = extra_hash[:document_type]
      result_hash[:"description"] = extra_hash[:description]
      return result_hash
    end
    
    def get_file(file_id)
      result = get_file_info(file_id)
      file_result =    @@client.request :ser, :document_get do |soap|
                    soap.xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service3.base.module.n5ic/\">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <ser:documentGet>"+file_id+"</ser:documentGet>
                       </soapenv:Body>
                    </soapenv:Envelope>"
                  end
      file_hash = file_result.to_hash[:document_get_response]
      result[:"base64_data"] = file_hash
      result[:"file_path"] = decode_file(result)
      result.delete(:base64_data) # Releasing som memory hungry stuff
      return result
    end
    
    def decode_file(hash)
      f = StringIO.new
      open(hash[:title] +"."+ hash[:format], "w+b") do# |f|
        f << Base64.decode64(hash[:base64_data])
      end
      puts "\nf contents:\n#{f.string}\n"
      file = Tempfile.open([hash[:title], "."+ hash[:format]], "#{Rails.root}/tmp").binmode
      begin
        file << f.string
        file.flush
      end
      return file.path
    end  
  end
end