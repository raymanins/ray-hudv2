window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'update_hud') {
        updateBar('health', data.health);
        updateBar('armor', data.armor);
        updateBar('food', data.food);
        updateBar('water', data.water);

        const speedElement = document.getElementById('speed-value');
        if (speedElement) {
            speedElement.innerText = data.speed;
        }

        const seatbeltElement = document.getElementById('seatbelt');
        if (seatbeltElement) {
            if (data.seatbelt) {
                seatbeltElement.classList.add('green');
                seatbeltElement.classList.remove('red');
            } else {
                seatbeltElement.classList.add('red');
                seatbeltElement.classList.remove('green');
            }
        }

        const topHud = document.getElementById('top-hud');
        if (topHud) {
            if (data.speed > 0 || data.seatbelt) {
                topHud.style.display = 'flex';
            } else {
                topHud.style.display = 'none';
            }
        }

        updateVoiceBar(data);
        
    } else if (data.action === 'toggle_hud') {
        const hudElement = document.getElementById('hud');
        if (hudElement) {
            hudElement.style.display = data.enabled ? 'flex' : 'none';
        }
    }
});

function updateBar(id, value) {
    const bar = document.querySelector(`#${id}-bar > div`);
    if (bar) {
        const percentage = Math.min(Math.max(value, 0), 100); // Ensure the value is between 0 and 100
        bar.style.width = `${percentage}%`;
    }
}

function updateVoiceBar(data) {
    const voiceBar = document.querySelector('#voice-bar > div');
    if (voiceBar) {
        if (data.talking) {
            voiceBar.style.backgroundColor = 'orange';
            if (data.proximity <= 2) {
                voiceBar.style.width = '25%'; // Shouting
            } else if (data.proximity <= 3) {
                voiceBar.style.width = '50%'; // Talking
            } else {
                voiceBar.style.width = '100%'; // Whispering
            }
        } else {
            voiceBar.style.backgroundColor = 'grey';
            voiceBar.style.width = '0%'; // Silence
        }
    }
}

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('hud').style.display = 'none';
});
