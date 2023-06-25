module VisitCounter
  extend ActiveSupport::Concern

  included do
    helper_method :visit_counter
  end

  private

  def visit_counter
    @visit_counter = session[:visit_counter]
  end

  def increment_counter
    if session[:visit_counter].nil?
      session[:visit_counter] = 0
    else
      session[:visit_counter] += 1
    end
  end

  def reset_counter
    session[:visit_counter] = 0
  end
end
