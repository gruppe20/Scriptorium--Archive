require "savon"

class SOAP {
  def get_fonds_series
    client = Savon::Client.new("http://ark1.hio.no/n5/Noark5BaseService3?wsdl")
    result = client.request :ser, :fonds_get_series, body: "c8637365-8691-4ef8-aae3-a2d7df757dd1"
    data = result.to_hash
    
    # @title = data[:title]
    #  @created_by = data[:created_by]
    #  @cdate = data[:created_date]
    #  @desc = data[:description]
    #  @medium = data[:document_medium]
    #  @sys_id = data[:system_id]
    
    return data
  end
}