# Pong Game in x86 Assembly

Forked from https://github.com/arham2211/ping-pong-x86-game

To test this project on Windows, run the commands:
```
git clone --recursive https://github.com/TheGabmeister/pong-x86-assembly.git
cd pong-x86-assembly
extract-Irvine32.bat
```
The batch file will extract the Irvine library from the submodule, and will delete the submodule. Open `pong.sln` using Visual Studio 2022. It should have all the necessary includes already set up and will link to Irvine32.lib automatically when you run it.

# Controls
- A and W for moving the paddles up and down for Player 1.
- O and L for moving the paddles up and down for Player 2.

# Issues
- You cannot press two keys at the same time. When Player 1 is pressing a button, Player 2 cannot move.