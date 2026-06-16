document.addEventListener('DOMContentLoaded', function () {
    var serviceCards = document.querySelectorAll('.service-card');
    var serviceTypeInput = document.getElementById('serviceType');
    var servicePriceInput = document.getElementById('servicePrice');
    var vehicleSelect = document.getElementById('vehicleSelect');
    var scheduledDateInput = document.getElementById('scheduledDate');
    var scheduledTimeSelect = document.getElementById('scheduledTime');
    var summaryVehicle = document.getElementById('summaryVehicle');
    var summaryService = document.getElementById('summaryService');
    var summaryDate = document.getElementById('summaryDate');
    var summaryTime = document.getElementById('summaryTime');
    var summaryPrice = document.getElementById('summaryPrice');
    var bookingForm = document.getElementById('bookingForm');
    var bookingError = null;

    function createErrorContainer() {
        if (!bookingError) {
            bookingError = document.createElement('div');
            bookingError.id = 'bookingError';
            bookingError.className = 'booking-alert error-alert';
            bookingError.style.display = 'none';
            bookingError.style.marginBottom = '1rem';
            var panel = document.querySelector('.booking-panel');
            if (panel) {
                panel.insertBefore(bookingError, panel.firstChild);
            }
        }
    }

    function showError(message) {
        createErrorContainer();
        if (bookingError) {
            bookingError.textContent = message;
            bookingError.style.display = 'flex';
            bookingError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }

    function hideError() {
        if (bookingError) {
            bookingError.style.display = 'none';
        }
    }

    function formatPrice(value) {
        var amount = Number(value) || 0;
        return amount.toLocaleString('vi-VN') + 'đ';
    }

    function formatDate(value) {
        if (!value) {
            return 'Not selected';
        }
        return value;
    }

    function updateSummary() {
        var vehicleText = 'Not selected';
        if (vehicleSelect && vehicleSelect.value) {
            var selectedOption = vehicleSelect.options[vehicleSelect.selectedIndex];
            if (selectedOption && selectedOption.text) {
                vehicleText = selectedOption.text;
            }
        }

        if (summaryVehicle) {
            summaryVehicle.textContent = vehicleText;
        }
        if (summaryService) {
            summaryService.textContent = serviceTypeInput.value || 'Not selected';
        }
        if (summaryDate) {
            summaryDate.textContent = formatDate(scheduledDateInput ? scheduledDateInput.value : '');
        }
        if (summaryTime) {
            summaryTime.textContent = scheduledTimeSelect && scheduledTimeSelect.value ? scheduledTimeSelect.value : 'Not selected';
        }
        if (summaryPrice) {
            summaryPrice.textContent = servicePriceInput.value && Number(servicePriceInput.value) > 0 ? formatPrice(servicePriceInput.value) : '0đ';
        }
    }

    function clearActiveServices() {
        for (var i = 0; i < serviceCards.length; i++) {
            serviceCards[i].classList.remove('active');
        }
    }

    function selectService(card) {
        if (!card) {
            return;
        }
        clearActiveServices();
        card.classList.add('active');
        var service = card.getAttribute('data-service') || '';
        var price = card.getAttribute('data-price') || '0';
        if (serviceTypeInput) {
            serviceTypeInput.value = service;
        }
        if (servicePriceInput) {
            servicePriceInput.value = price;
        }
        updateSummary();
        hideError();
    }

    function setMinBookingDate() {
        if (!scheduledDateInput) {
            return;
        }
        var now = new Date();
        var year = now.getFullYear();
        var month = now.getMonth() + 1;
        var day = now.getDate();

        if (month < 10) {
            month = '0' + month;
        }
        if (day < 10) {
            day = '0' + day;
        }

        scheduledDateInput.setAttribute('min', year + '-' + month + '-' + day);
    }

    function isDateInPast(dateValue) {
        if (!dateValue) {
            return false;
        }
        var selectedDate = new Date(dateValue + 'T00:00:00');
        var now = new Date();
        now.setHours(0, 0, 0, 0);
        return selectedDate.getTime() < now.getTime();
    }

    for (var i = 0; i < serviceCards.length; i++) {
        serviceCards[i].addEventListener('click', function (event) {
            event.preventDefault();
            selectService(this);
        });
    }

    if (vehicleSelect) {
        vehicleSelect.addEventListener('change', function () {
            updateSummary();
        });
    }

    if (scheduledDateInput) {
        scheduledDateInput.addEventListener('change', function () {
            updateSummary();
        });
    }

    if (scheduledTimeSelect) {
        scheduledTimeSelect.addEventListener('change', function () {
            updateSummary();
        });
    }

    if (bookingForm) {
        bookingForm.addEventListener('submit', function (event) {
            hideError();
            if (!serviceTypeInput || !serviceTypeInput.value) {
                event.preventDefault();
                showError('Please select a wash service before submitting your booking.');
                return false;
            }
            if (!vehicleSelect || !vehicleSelect.value) {
                event.preventDefault();
                showError('Please select a vehicle before submitting your booking.');
                return false;
            }
            if (!scheduledDateInput || !scheduledDateInput.value) {
                event.preventDefault();
                showError('Please choose a booking date.');
                return false;
            }
            if (isDateInPast(scheduledDateInput.value)) {
                event.preventDefault();
                showError('Booking date cannot be in the past.');
                return false;
            }
            if (!scheduledTimeSelect || !scheduledTimeSelect.value) {
                event.preventDefault();
                showError('Please select a time slot.');
                return false;
            }
            return true;
        });
    }

    setMinBookingDate();
    updateSummary();
});
