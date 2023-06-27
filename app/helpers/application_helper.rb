module ApplicationHelper
  def render_if(condition, record)
    return unless condition

    render record
  end
end
