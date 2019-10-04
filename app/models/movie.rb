class Movie < ActiveRecord::Base
  def create
    @movie = movie.create movie_params
  end


  def self.movies(filters, sorting_criteria)
    return self.order(sorting_criteria) if not filters
    self.where({:rating => filters}).order(sorting_criteria)
  end


  def self.ratings
    self.pluck(:rating).uniq
  end


  def self.set_options(params, session)
    setup={:redirect => false}
    setup[:ratings] = if params[:ratings]
      if params[:ratings].kind_of? Hash
        params[:ratings].keys
      else
        params[:ratings]
      end
    elsif session[:ratings]
      setup[:redirect]=true
      session[:ratings]
    else
      self.ratings
    end

    setup[:order_by] = if params[:order_by]
      params[:order_by]
    elsif session[:order_by]
      setup[:redirect]=true
      session[:order_by]
    else
      nil
    end


    setup
  end


  private
  def movie_params
    params.require(:movie).permit(
      :title,
      :rating,
      :description,
      :release_date
    )
  end

end
