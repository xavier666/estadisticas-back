module ModalHelper
  def modal modal_content, size = nil
    size = size.to_sym if size
    case size
      when :small
        modal_size = "modal-sm"
      when :large
        modal_size = "modal-lg"
      end
    render partial: "inc/modal", locals: {modal_content: modal_content, size: modal_size}
  end
end