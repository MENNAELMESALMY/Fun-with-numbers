@echo off
If not exist minigame.asm echo File Does Not Exist
If not exist minigame.asm goto end

If exist minigame.obj erase minigame.obj
If exist minigame.exe erase minigame.exe
If exist minigame.ist erase minigame.ist

If exist graphics.obj erase graphics.obj
If exist graphics.exe erase graphics.exe
If exist graphics.ist erase graphics.ist

masm graphics,graphics,graphics;
if not exist graphics.obj goto end

masm minigame,minigame,minigame;
if not exist minigame.obj goto end


link minigame.obj+graphics.obj,game;
If not exist game.exe goto end

game.exe

:end