class ApplicationDecorator < Draper::Decorator
  decorates_finders
  delegate_all

  def editable field

    h.render :partial => 'shared/editable_field', :locals => {
        type: self.class.name.gsub('Decorator','').downcase,
        prop: field.to_s,
        object: self
    }
  end

end
