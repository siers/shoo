module ApplicationHelper
  def body_class
    params.slice(:controller, :action).values.join(' ')
  end
end
