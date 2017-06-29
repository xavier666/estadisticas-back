module JsonRendering
  extend ActiveSupport::Concern

  private

    def expose object, user_options = {}
      render_options = {
        json: object,
        status: :ok,
        meta: {},
        request_root: request.base_url
      }.merge! user_options

      if object.is_a? ActiveRecord::Relation and object.respond_to?(:current_page)
        render_options[:meta] ||= {}
        render_options[:meta][:pagination] = {
          current_page:   object.current_page,
          next_page:      object.next_page,
          offset:         object.offset,
          per_page:       object.per_page,
          previous_page:  object.previous_page,
          total_entries:  object.total_entries,
          total_pages:    object.total_pages
        }
      end

      if object.is_a? ActiveRecord::Base and object.errors.any?
        render_options[:meta] ||= {}
        render_options[:meta][:errors] = object.errors
        render_options[:status] = :bad_request
      else
      end
      render render_options
    end
end