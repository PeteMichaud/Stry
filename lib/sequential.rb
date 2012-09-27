module Sequential

  def insert_object collection, obj, after_id = nil
    raise "Cannot Insert Nil Object" unless obj.present?
    previous_obj = obj.class.name.constantize.find after_id unless after_id.blank?
    obj.sequence = previous_obj.present? ? previous_obj.sequence + 1 : 0
    collection.where("sequence >= ?", obj.sequence).each do |obj|
      obj.sequence += 1
      obj.save
    end
    obj.save
  end

  def remove_object collection, obj
    raise "Cannot Remove Nil Object" unless obj.present?
    collection.delete obj
    obj.destroy
    collection.each_with_index do |obj, index|
      obj.sequence = index
      obj.save
    end
  end

end