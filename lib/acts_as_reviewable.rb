require 'review'

module ActsAsReviewable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  # Methods to be added to classes which contain acts_as_reviewable
  module Behavior
    def self.included(base)
      # Extend the Behaviors::ClassMethods into this
      # ActiveRecord subclass
      base.extend(ClassMethods)
    end
    
    def reviews
      Review.find(:all, :conditions => ["object_type = ? and object_id = ?", "resctr_hotel", hotel_id], :order => "created_at desc")
    end

    def add_review(reviewer_name, reviewer_email, rating, title, review)
      r = Review.new
      r.reviewer_name = reviewer_name
      r.reviewer_email = reviewer_email
      r.rating = rating
      r.title = title
      r.review = review
      r.object_type = "resctr_hotel"
      r.object_id = hotel_id
      if r.save
        return reviews
      else
        return nil
      end
    end

    def rating
      total = 0
      reviews.each {|r| total += r.rating }
      if total > 0
        total / reviews.length
      else
        return nil
      end
    end
    
    # Methods to be added to the checksummed class, rather than
    # the instance
    module ClassMethods
    end
  end
  
  module ClassMethods
    def acts_as_reviewable
      include ActsAsReviewable::Behavior
    end
  end
  
end