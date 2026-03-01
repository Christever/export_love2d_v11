REM Nettoyage des anciens fichiers
        del BuildDesktop\*.* /Q /S
        
REM Version Windows
    REM Construction de la version 64 bits


        cd .\Source
        ..\tools64\7za a -tzip ..\BuildDesktop\64Bits\game.love
        cd ..
        cd tools64

        copy /b love.exe+..\BuildDesktop\64Bits\game.love ..\BuildDesktop\64Bits\game.exe
        copy /b *.dll ..\buildDesktop\64Bits\
        del ..\BuildDesktop\64Bits\game.love

        cd ..

    REM Construction de la version 32 bits

        cd .\Source
        ..\tools32\7za a -tzip ..\BuildDesktop\32Bits\game.love
        cd ..
        cd tools32

        copy /b love.exe+..\BuildDesktop\32Bits\game.love ..\BuildDesktop\32Bits\game.exe
        copy /b *.dll ..\buildDesktop\32Bits\
        del ..\BuildDesktop\32Bits\game.love

        cd ..
        
    REM Version Windows compressé - deux versions

        cd BuildDesktop\32Bits\
        ..\..\tools32\7za a -tzip gameDesktop32.zip 
        cd ..
        cd 64Bits
        ..\..\tools64\7za a -tzip gameDesktop64.zip 
        cd ..
        cd ..
    

REM Version Web

    cd web
    del ..\BuildWeb\*.* /Q /S

    cd ..
    cd web\release-compatibility

REM move ..\..\Source\conf.lua ..\..\conf.lua


    ..\Python27\python.exe ..\..\web\emscripten\tools\file_packager.py game.data --preload "..\..\Source"@/ --js-output=game.js
    xcopy *.* ..\..\BuildWeb /S
    cd ..
    cd ..

REM move conf.lua Source\conf.lua
    cd BuildWeb
    ..\tools32\7za a -tzip game.zip 

    cd ..
