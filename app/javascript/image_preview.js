document.addEventListener('turbo:load', () => {
    const fileInput = document.querySelector('input[type="file"]');
    const previewContainer = document.getElementById('image-preview');

    fileInput?.addEventListener('change', (event) => {
        const file = event.target.files[0];
        const reader = new FileReader();

        reader.onload = (e) => {
        previewContainer.innerHTML = file ? `<img src="${e.target.result}" alt="Preview" class="img-preview w-100 thumbnail" />` : '';
        };
        
        if (file) reader.readAsDataURL(file);
    });
});
  