require 'pry'

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Reservable

  def city_openings(start_date, end_date)
    # binding.pry
    openings(start_date, end_date)
  end
end