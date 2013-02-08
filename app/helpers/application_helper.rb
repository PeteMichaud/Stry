module ApplicationHelper

  def form_control form, object, field_symbol, field_type = :text_field
    render :partial => 'shared/form_control',
           :locals => {
               :f               => form,
               :field_method    => form.method(field_type),
               :object          => object,
               :field_sym       => field_symbol,
           }
  end

  def form_submit submit_text, cancel_path = nil
    cancel_path = root_path if cancel_path.nil?
    render :partial => 'shared/form_submit',
           :locals => {
               :submit_text     => submit_text,
               :cancel_path     => cancel_path
           }
  end

  def add_button type
    render :partial => 'shared/add_button',
           :locals => {
               :type     => type,
           }
  end

  def edit_mode?
    false
  end

end
