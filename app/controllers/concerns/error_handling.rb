module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :error_handler
  end

  private

    def error_handler exception
      map_error_to_status exception
      response_body = {
        errors: [{
          status: @status_code, detail: exception.message
        }]
      }
      render(json: response_body, status: @status_code) and return
    end

    def map_error_to_status exception
      @status_code = case exception.class.to_s
        when "API::Unauthorized"
          :unauthorized
        when "API::Forbidden"
          :forbidden
        when "API::AuthorizationTimeout"
          419
        when "ActiveRecord::RecordNotFound"
          :not_found
        when "ActiveRecord::RecordInvalid"
          :bad_request
        else
          output_stack_trace exception unless Rails.env == "production"
          :bad_request
        end
    end

    def output_stack_trace e
      puts "\n\n#{e.message}\n"
      puts e.backtrace.join("\n")
      puts "\n\n"
    end
end