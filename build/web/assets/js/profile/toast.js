document.addEventListener('DOMContentLoaded', function() {
    const toast = document.getElementById('toastMsg');
    if (toast) {
        setTimeout(function() {
            toast.style.animation = 'fadeOut 0.4s ease forwards';
            setTimeout(function() { toast.remove(); }, 400);
        }, 3500);
    }
});
