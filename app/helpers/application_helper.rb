module ApplicationHelper
    include Pagy::Frontend

    def toastify_flash
        return '' if request.path.start_with?('/users') # Skip if path starts with '/users'
        flash.each_with_object([]) do |(type, message), flash_messages|
          flash_messages << "Toastify({
            text: '#{message}',
            duration: 3000,
            close: true,
            gravity: 'top',
            position: 'center',
            stopOnFocus: true,
            style: { background: '#{type == 'notice' ? 'green' : '#DC143C'}' }
          }).showToast();"
        end.join("\n").html_safe
    end
end
