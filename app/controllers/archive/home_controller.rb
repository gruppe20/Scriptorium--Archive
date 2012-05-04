module Archive
  class HomeController < ApplicationController
    def index
      shampoo = SOAP::new
      @data = shampoo.get_fonds_series
    end
  
  end
end
