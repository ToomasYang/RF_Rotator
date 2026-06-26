<img class="ui image" src="./images/rotator.jpg">

# RF_Rotator
*PLEASE NOTE:* This repository only includes the python code for the Raspberry Pi and the webpage. However, this does not include how to build the frame! It was 3D printed from a colleague, and I do not have the source files for it. (Sorry!)

# Quick Setup (venv)

Run this once on the Raspberry Pi to create a virtual environment and install Python packages:

```bash
chmod +x ./setup_venv.sh
./setup_venv.sh
```

Use a custom venv path if needed:

```bash
./setup_venv.sh ~/rf_rotator_venv
```

Then run the app:

```bash
~/venv/bin/python ./rf_rotator
```

# Troubleshooting: SPI Permission Denied

If the app logs `PermissionError: [Errno 13]` when opening SPI, enable SPI and grant your user SPI access:

```bash
sudo raspi-config nonint do_spi 0
sudo usermod -aG spi $USER
sudo reboot
```

After reboot, verify device nodes exist:

```bash
ls -l /dev/spidev*
```

If your service runs as a custom user, make sure that user is in the `spi` group.

# Functionalities
<img class="ui image" src="./images/controlpanel.png">

- Change rotation speed of motor
- Live update of angle reading to webpage
- Change refresh rate of live updates
- Record time v.s. angle measurements into file
- Bi-directional
- Access localhost/angle.json for full reading with timestamp
- Set zero degree mark for encoder
- Reset the rotator back to the zero degree mark

# Materials
- 1 Trinamic QSH4218-35-18-027 stepper motor
- 1 Raspberry Pi 3 w/ Waveshare Stepper Motor HAT
- 1 CUI AMT22 Modular Absolute Encoders 12 bit Single-Turn
- 1 SPI cable, with female headers -> male SPI interface

## Waveshare HAT Notes

- The motor control code in `rf_rotator` now uses the DRV8825 GPIO interface used by the Waveshare Stepper Motor HAT.
- Default motor channel is M1 (BCM pins DIR=13, STEP=19, EN=12, MODE=16/17/20).
- If your wiring is on M2 or uses different pins, update `WS_DIR_PIN`, `WS_STEP_PIN`, `WS_ENABLE_PIN`, and `WS_MODE_PINS` in `rf_rotator`.
- `WS_CONTROL_MODE = 'hardward'` means microstep mode comes from DIP switches.
- Keep `MICROSTEPS` in code consistent with the DIP microstep setting so timing and degree calculations remain accurate.

# Improvements / Problems
- Page remains unresponsive once you start rotating (still updates angle reading), becomes responsive once it stops rotating
  - Possible solution: Run on a child process/parallel thread
- Motor does not move in a smooth motion; jittery as it rotates
  - Possible solution: Up the SPI refresh rate, purchase a different motor
- Rotation Speed (RPM) currently not accurate, modeling of timing between microsteps inconsistent when implemented from a standalone to the server
- When resetting or turning to a specific amount of degrees, the error margin is +/- 2 degrees
- Bad convention for dealing with web forms (how user data is inputted): Using a chained if/else to determine which button was pressed
