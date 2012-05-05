module Archive
  class HomeController < ApplicationController
    def index
      shampoo = SOAP::new
      # @data = shampoo.get_specific_series("test")
      # @data = shampoo.create_file("test", "railsTest2", "Test from RoR2", "rortest", "automagic", "rails")
      # @data = shampoo.create_child_file("d960e224-0d23-4dbf-9478-ba336247010e", "railsChild", "Sounds naughtier that it is", "rortest", "electronic", "rails")
      #@data = shampoo.create_record("97419d1d-046b-44b0-8f58-0bb4aa803cfe", "railsRecord", "Rails world record", "rortest", "electronic", "rails")
      #@data = shampoo.create_file("09f0ecfc-06c3-47a4-85f7-5636eb3e4aad", "Image/PNG", "rails upload 2", "rortest", "rails", "/Volumes/Ekkokammer/jr/Pictures/Dogcow.png")
      @data = shampoo.get_file("1a0c133b-96e0-4a6b-9a02-7c6842882f9a")
      send_file(@data[:file_path])
    end
  
  end
end
