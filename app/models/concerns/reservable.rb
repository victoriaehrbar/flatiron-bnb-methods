require 'pry'

module Reservable
    extend ActiveSupport::Concern

    def openings(start_date, end_date)
        # binding.pry
        listings.merge(Listing.available(start_date, end_date))
    end
end