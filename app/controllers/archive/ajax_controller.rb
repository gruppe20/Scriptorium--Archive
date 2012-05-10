module Archive
  class AjaxController < ApplicationController
    @@shampoo = SOAP::new
    
    def test_call
      @data = "AJAX FTW!"
      render :inline => @data
    end
    
      
      # @data = @@shampoo.get_specific_series("test")
      # @data = @@shampoo.create_file("test", "railsTest2", "Test from RoR2", "rortest", "automagic", "rails")
      # @data = @@shampoo.create_child_file("d960e224-0d23-4dbf-9478-ba336247010e", "railsChild", "Sounds naughtier that it is", "rortest", "electronic", "rails")
      #@data = @@shampoo.create_record("97419d1d-046b-44b0-8f58-0bb4aa803cfe", "railsRecord", "Rails world record", "rortest", "electronic", "rails")
      #@data = @@shampoo.create_file("09f0ecfc-06c3-47a4-85f7-5636eb3e4aad", "Image/PNG", "rails upload 2", "rortest", "rails", "/Volumes/Ekkokammer/jr/Pictures/Dogcow.png")
      #@data = @@shampoo.get_file("1a0c133b-96e0-4a6b-9a02-7c6842882f9a")

    # 66b2ed65-901c-437d-9d72-564dd00b3ef1
    def get_series
      render :json => @@shampoo.get_fonds_series(params[:fond_id])
    end
    
    def get_case_files
      render :json => @@shampoo.get_case_files(params[:series_id])
    end
    
    def get_child_case_files
      render :json => @@shampoo.get_child_case_files(params[:case_file_id])
      #render :inline => @@shampoo.get_child_case_files(params[:case_file_id]).to_json
    end
    
    def get_records
      render :json => @@shampoo.get_registry_entries(params[:case_file_id])
    end
    
    def get_record
      render :json => @@shampoo.get_record(params[:record_id])
    end
    
    def get_document_description(record_id)
      
    end
    
    def get_document(document_id)
      @file = @@shampoo.get_file(document_id)
      send_file(@file[:file_path])
    end
  end
end