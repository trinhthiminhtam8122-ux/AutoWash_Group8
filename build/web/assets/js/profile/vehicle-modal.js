function openAddModal() {
    document.getElementById('modalTitle').innerText = 'Add Vehicle';
    document.getElementById('modalDesc').innerText = 'Save your vehicle information for faster booking next time.';
    document.getElementById('modalAction').value = 'add';
    document.getElementById('modalVehicleID').value = '';
    document.getElementById('modalOldImage').value = '';
    
    document.getElementById('modalLicense').value = '';
    document.getElementById('modalBrand').value = '';
    document.getElementById('modalModel').value = '';
    document.getElementById('modalType').value = '';
    document.getElementById('modalColor').value = '';
    
    const previewImg = document.getElementById('modalPreviewImg');
    if (previewImg) {
        previewImg.style.display = 'none';
        previewImg.src = '';
    }
    const uploadContent = document.getElementById('modalUploadContent');
    if (uploadContent) {
        uploadContent.style.background = 'transparent';
        uploadContent.style.padding = '0';
    }
    
    document.getElementById('vehicleModalOverlay').style.display = 'flex';
}

function openEditModal(id, license, fullModel, color, imageUrl, contextPath) {
    document.getElementById('modalTitle').innerText = 'Edit Vehicle';
    document.getElementById('modalDesc').innerText = 'Update your vehicle information below.';
    document.getElementById('modalAction').value = 'edit';
    document.getElementById('modalVehicleID').value = id;
    document.getElementById('modalOldImage').value = imageUrl;
    
    document.getElementById('modalLicense').value = license;
    document.getElementById('modalColor').value = color;
    
    // Parse full model "Brand Model - Type"
    let brand = "", model = "", type = "";
    if (fullModel && fullModel.includes(" - ")) {
        let parts = fullModel.split(" - ");
        type = parts[1].trim();
        let brandModel = parts[0];
        if (brandModel.includes(" ")) {
            brand = brandModel.substring(0, brandModel.indexOf(" ")).trim();
            model = brandModel.substring(brandModel.indexOf(" ")).trim();
        } else {
            brand = brandModel;
        }
    } else {
        brand = fullModel || "";
    }
    
    document.getElementById('modalBrand').value = brand;
    document.getElementById('modalModel').value = model;
    document.getElementById('modalType').value = type;
    
    if (imageUrl && imageUrl !== 'null' && imageUrl !== '') {
        const prefix = contextPath + (imageUrl.startsWith('/') ? '' : '/');
        const previewImg = document.getElementById('modalPreviewImg');
        if (previewImg) {
            previewImg.src = prefix + imageUrl;
            previewImg.style.display = 'block';
        }
        const uploadContent = document.getElementById('modalUploadContent');
        if (uploadContent) {
            uploadContent.style.background = 'rgba(255,255,255,0.8)';
            uploadContent.style.padding = '10px';
            uploadContent.style.borderRadius = '8px';
        }
    } else {
        const previewImg = document.getElementById('modalPreviewImg');
        if (previewImg) {
            previewImg.style.display = 'none';
            previewImg.src = '';
        }
        const uploadContent = document.getElementById('modalUploadContent');
        if (uploadContent) {
            uploadContent.style.background = 'transparent';
            uploadContent.style.padding = '0';
        }
    }
    
    document.getElementById('vehicleModalOverlay').style.display = 'flex';
}

function closeModal() {
    document.getElementById('vehicleModalOverlay').style.display = 'none';
}

function previewModalImage(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            const img = document.getElementById('modalPreviewImg');
            if (img) {
                img.src = e.target.result;
                img.style.display = 'block';
            }
            
            const content = document.getElementById('modalUploadContent');
            if (content) {
                content.style.background = 'rgba(255,255,255,0.8)';
                content.style.padding = '10px';
                content.style.borderRadius = '8px';
            }
        }
        reader.readAsDataURL(input.files[0]);
    }
}
