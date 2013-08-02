require_relative 'mongoid-embedded-errors-messages/version'
module MongoidEmbeddedErrorsMessages

  def self.included(klass)
    raise NotMongoidDocument unless klass.included_modules.include? Mongoid::Document
  end

  def embedded_errors_messages
    merged_errors = errors.messages
    embedded_relations.each do |relation, metadata|
      if metadata[:relation] == Mongoid::Relations::Embedded::Many
        errors = embedded_errors_for_embeds_many_relation(relation)
        merged_errors.merge!(errors) if errors.present?
      elsif metadata[:relation] == Mongoid::Relations::Embedded::One
        errors = embedded_errors_for_embeds_one_relation(relation)
        merged_errors.merge!(errors) if errors.present?
      end
    end
    merged_errors.present? ? merged_errors : nil
  end

  class NotMongoidDocument < Exception; end
  private
  def embedded_errors_for_embeds_many_relation(relation)
    errors_array = send(relation).map{|doc| doc.try(:embedded_errors_messages)}
    if errors_array.compact.present?
      children_errors = {relation.to_sym => errors_array}
      children_errors.delete_if{|k,v| v.blank? }
    end
    children_errors
  end

  def embedded_errors_for_embeds_one_relation(relation)
    relation_errors = send(relation).try(:embedded_errors_messages)
    { relation.to_sym => relation_errors } if relation_errors.present?
  end
end
