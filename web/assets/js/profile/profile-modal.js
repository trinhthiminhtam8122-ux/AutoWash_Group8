function openEditProfileModal(el) {
    const fullName = el.dataset.name || '';
    const phone    = el.dataset.phone || '';
    const email    = el.dataset.email || '';
    document.getElementById('modalFullName').value = (fullName === 'Guest') ? '' : fullName;
    document.getElementById('modalEmail').value    = (email === 'N/A')     ? '' : email;
    document.getElementById('modalPhone').value    = (phone === 'N/A')     ? '' : phone;
    document.getElementById('profileModalOverlay').style.display = 'flex';
}

function closeProfileModal() {
    document.getElementById('profileModalOverlay').style.display = 'none';
}

document.addEventListener('DOMContentLoaded', function() {
    const editForm = document.getElementById('editProfileForm');
    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            const fullName = document.getElementById('modalFullName').value.trim();
            const email    = document.getElementById('modalEmail').value.trim();
            const phone    = document.getElementById('modalPhone').value.trim();
            const emailRx  = /^[\w.\-]+@[\w.\-]+\.[a-zA-Z]{2,}$/;
            const phoneRx  = /^[0-9]{9,11}$/;
            
            if (!fullName) { alert('Full name cannot be empty.'); e.preventDefault(); return; }
            if (!emailRx.test(email)) { alert('Invalid email format.'); e.preventDefault(); return; }
            if (!phoneRx.test(phone)) { alert('Phone must be 9–11 digits.'); e.preventDefault(); return; }
        });
    }
});
