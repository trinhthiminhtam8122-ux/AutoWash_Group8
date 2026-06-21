// main.js - Common scripts

// Navigation via POST to hide parameters
function navTo(action) {
    let form = document.getElementById('postNavForm');
    if (!form) {
        form = document.createElement('form');
        form.id = 'postNavForm';
        form.action = 'main';
        form.method = 'POST';
        form.style.display = 'none';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'action';
        input.id = 'postNavAction';
        form.appendChild(input);
        
        document.body.appendChild(form);
    }
    
    document.getElementById('postNavAction').value = action;
    form.submit();
}

// Toast auto-dismiss logic
document.addEventListener('DOMContentLoaded', function() {
    const toast = document.getElementById('toastMessage');
    if (toast) {
        setTimeout(() => {
            toast.style.animation = 'fadeOut 0.3s forwards';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
});
