require 'pry'

class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :description, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :title, presence: true

  after_save :set_host_as_host
  before_destroy :unset_host_as_host

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def self.available(start_date, end_date)
    results = []
    array_1=start_date.split("-").map{|s|s.to_i}
    array_2=end_date.split("-").map{|s|s.to_i}
    date_1=Date.new(array_1[0], array_1[1], array_1[2])
    date_2=Date.new(array_2[0], array_2[1], array_2[2])
    if start_date && end_date
      # binding.pry
      self.all.each do |l|
      #  l.reservations.each do |r|
      if l.reservations.none? {|r| (date_1..date_2).cover?(r.checkin) || (date_1..date_2).cover?(r.checkout)}
        results << l 
    
        end
      end


      # joins(:reservations).
      #   where.not(reservations: {checkin: start_date..end_date}) ||
      # joins(:reservations).
      #   where.not(reservations: {checkout: start_date..end_date})

    end
    results 
  end

  def unset_host_as_host
    
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(is_host: false)
    end
  end

  def set_host_as_host
    unless host.is_host?
      host.update(is_host: true)
    end
  end
end