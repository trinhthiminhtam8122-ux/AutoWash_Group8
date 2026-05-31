// auth.js - Scripts for Login and Register pages

function togglePassword(id) {
    // If id is provided, use it, else default to 'password'
    var inputId = id || "password";
    var x = document.getElementById(inputId);
    
    // Find the closest eye icon or use the first one
    var icon = x.nextElementSibling;
    if (!icon || !icon.classList.contains('eye-icon')) {
        icon = document.querySelector(".eye-icon");
    }
    
    if (x.type === "password") {
        x.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        x.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}
