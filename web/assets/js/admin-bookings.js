(function () {
    function formatSeconds(seconds) {
        var safeSeconds = Math.max(0, seconds || 0);
        var minutes = Math.floor(safeSeconds / 60);
        var remain = safeSeconds % 60;
        return String(minutes).padStart(2, "0") + ":" + String(remain).padStart(2, "0");
    }

    function readSeconds(element) {
        var value = parseInt(element.getAttribute("data-seconds"), 10);
        return isNaN(value) ? 0 : value;
    }

    function updateTimerElement(element) {
        var seconds = readSeconds(element);
        if (seconds > 0) {
            seconds -= 1;
            element.setAttribute("data-seconds", seconds);
        }
        element.textContent = element.textContent === "-" ? "-" : formatSeconds(seconds);
        if (seconds <= 0 && element.textContent !== "-") {
            element.classList.add("is-zero");
        }
        return seconds;
    }

    function markNeedCheckout(row) {
        var status = row.querySelector(".row-status");
        if (status) {
            status.textContent = "Need Check-out";
            status.classList.remove("washing");
            status.classList.add("need-checkout");
        }

        var waitingLabel = row.querySelector(".waiting-label");
        var checkoutForm = row.querySelector(".checkout-form");
        if (waitingLabel && checkoutForm) {
            waitingLabel.classList.add("is-hidden");
            checkoutForm.classList.remove("is-hidden");
        }
    }

    function tick() {
        document.querySelectorAll(".timer-value[data-seconds]").forEach(function (timer) {
            if (timer.textContent.trim() === "-") {
                return;
            }

            var seconds = updateTimerElement(timer);
            var row = timer.closest("tr");
            if (seconds <= 0 && row) {
                markNeedCheckout(row);
            }
        });

        document.querySelectorAll(".station-timer[data-seconds]").forEach(function (timer) {
            if (timer.textContent.trim() === "-") {
                return;
            }

            var seconds = updateTimerElement(timer);
            if (seconds <= 0) {
                var stationStatus = document.querySelector(".station-status");
                if (stationStatus) {
                    stationStatus.textContent = "Need Check-out";
                    stationStatus.classList.remove("washing");
                    stationStatus.classList.add("need-checkout");
                }
            }
        });
    }

    window.setInterval(tick, 1000);
})();
