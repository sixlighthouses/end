class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :home, :about, :contact ]
  def home
  end

  def about
  end

  def contact
  end
end
