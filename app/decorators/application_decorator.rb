class ApplicationDecorator < Draper::Decorator
  decorates_finders
  delegate_all

  def show field, edit_mode
    if edit_mode
      editable field
    else
      tag = :div
      css_class = "#{type}-#{field}"
      case css_class
        when "story-title" then tag = :h1
        when "scene-title" then tag = :h2
        else css_class += " readable"
      end
      h.content_tag tag, (self.send(field) || "").html_safe, class: css_class
    end
  end

  def editable field

    h.render :partial => 'shared/editable_field', :locals => {
        type: type,
        prop: field.to_s,
        object: self
    }
  end

  private

  def type
    self.class.name.gsub('Decorator','').downcase
  end

end
