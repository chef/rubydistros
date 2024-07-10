FROM mcr.microsoft.com/windows/servercore:ltsc2019

ENV BUNDLE_SILENCE_ROOT_WARNING=true \
    GIT_DISCOVERY_ACROSS_FILESYSTEM=true

# When launched by user, default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

# Install 7zip
RUN powershell -Command (New-Object System.Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z2407-x64.exe', 'c:\7z2407-x64.exe'); \
  Start-Process -FilePath 'c:\7z2407-x64.exe' -Args "/S" -Verb RunAs -Wait ; \
  [Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\Program Files\7-Zip', [EnvironmentVariableTarget]::Machine); \
  Remove-Item 'C:\7z2407-x64.exe'

# Download Ruby archive, extract it and add the "bin" folder to the PATH variable
RUN powershell -Command (New-Object System.Net.WebClient).DownloadFile('https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.3-1/rubyinstaller-3.3.3-1-x64.7z', 'C:\rubyinstaller-3.3.3-1-x64.7z'); \
  7z x -o'C:\' rubyinstaller-3.3.3-1-x64.7z -r ; \
  [Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\rubyinstaller-3.3.3-1-x64\bin', [EnvironmentVariableTarget]::Machine); \
  Remove-Item 'C:\rubyinstaller-3.3.3-1-x64.7z'

# Download MSYS2 dev kit, extract it and add to the PATH variable

RUN powershell -Command (New-Object System.Net.WebClient).DownloadFile('https://github.com/msys2/msys2-installer/releases/download/2024-05-07/msys2-x86_64-20240507.exe', 'c:\\msys2-x86_64-20240507.exe'); \
   .\msys2-x86_64-20240507.exe in --confirm-command --accept-messages --root C:\msys2 ; \
   [Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\msys2', [EnvironmentVariableTarget]::Machine); \
   Remove-Item 'C:\msys2-x86_64-20240507.exe'

RUN ruby --version
RUN bundler --version   