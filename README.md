<h1>DE10 Audio Game</h1>
<h2>Project Description:</h2>
This project is an audio-based memory game running on Intel’s SoC FPGA platform. Running on the DE10 Standard embedded board, it maps the four buttons to four unique audio samples and generates a sequence of these audio samples to play from the WM8731 audio codec through the line out port on the board. The goal of the player is to press the buttons which are mapped to the four audio samples to generate the same sequence of audio samples outputted by the board, with each round the sequence will increment by 1, increasing difficulty of the game. By utilizing both the Hard Processing System (HPS) and FPGA fabric, the application delivers a responsive interaction that combines audio, button input, and hex display feedback. 

The HPS is responsible for executing the game logic features of this application. For example, the audio sample sequence generation/randomization as well as keeping track of sequence length. The HPS will check to see if the user’s button input is correct and matches the sequence, if not it is also responsible for resetting the game upon failure. The HPS communicates the audio samples to play over the lightweight AXI bridge into the FPGA’s memory mapped I/O. 

Audio output is configured using an I2C line connected to the FPGA and HPS, although the HPS only is responsible for the actual configuration. The output is set to operate in 16-bit I2S mode at 48 kHz so that it is prepared for audio input from the FPGA over I2S. The audio codec functions in slave mode, allowing the clock cycles to be set by the FPGA through its VLSI logic. Game progress and feedback such as current sequence length is displayed on the hex display. 

<h2>To Execute:</h2>

1. Clone the repository 

2. Navigate to 'audioGame' directory
 
3. Run CMake by running 'make'
 
4. Executable will be in /bin/, run './bin/audioGame'

<h2>System Design</h2>
<img width="485" height="435" alt="image" src="https://github.com/user-attachments/assets/b387ebf9-22d4-4af1-9e2c-38ee7cc6d220" />

<h2>File Structure:</h2>
<img width="226" height="495" alt="image" src="https://github.com/user-attachments/assets/57fe921f-23b9-479e-8c31-b4a336412bdd" />
