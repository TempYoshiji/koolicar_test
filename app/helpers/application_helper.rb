module ApplicationHelper
  def display_resource_errors(resource)
    return if resource.errors.blank?
    content_tag(:div, class: 'alert alert-danger') do
      resource.errors.full_messages.join('<br/>').html_safe
    end
  end
end
