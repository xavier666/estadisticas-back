class EstadisticasSerializer < ActiveModel::Serializer

  include Rails.application.routes.url_helpers

  def self.attributes(*attrs)
    attribute(:class_name)
    attribute(:class_name_human)
    attribute(:created_at)
    attribute(:errors)
    attribute(:gid)
    attribute(:id)
    attribute(:object_link)
    attribute(:persisted)
    attribute(:to_s)
    attribute(:updated_at)

    super
  end

  def class_name
    object.class.to_s
  end

  def class_name_human
    object.class.model_name.human
  end

  def errors
    object.errors
  end

  def gid
    object.persisted? ? object.to_global_id.to_s : nil
  end

  def object_link
    begin
      default_url_options[:host] =  @instance_options[:request_root]
      url_for(object)
    rescue
      nil
    end
  end

  def persisted
    object.persisted?
  end

  def to_s
    object.to_s
  end
end