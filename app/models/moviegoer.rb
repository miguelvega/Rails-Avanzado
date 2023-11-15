# Edit app/models/moviegoer.rb to look like this:
# app/models/moviegoer.rb
class Moviegoer < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    Moviegoer.create!(
      :provider => auth["provider"],
      :uid => auth["uid"],
      :name => auth["info"]["name"]
    )
  end
end

