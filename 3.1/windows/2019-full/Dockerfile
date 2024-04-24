FROM mcr.microsoft.com/windows:ltsc2019

ENV BUNDLE_SILENCE_ROOT_WARNING=true \
    GIT_DISCOVERY_ACROSS_FILESYSTEM=true

# When launched by user, default to PowerShell if no other command specified.
RUN ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

# Install Chocolatey (and essentials)
RUN powershell -Command "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && \
  C:\ProgramData\Chocolatey\bin\refreshenv && \
  choco feature enable -n=allowGlobalConfirmation && \
  choco config set cacheLocation C:\chococache && \
  choco upgrade chocolatey && \
  choco install git && \
  rmdir /q /s C:\chococache && \
  echo Chocolatey install complete -- closing out layer (this can take awhile)

# Install Ruby + Devkit
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
  Write-Output 'Downloading Ruby + DevKit'; \
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
  (New-Object System.Net.WebClient).DownloadFile('https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.1-1/rubyinstaller-devkit-3.1.1-1-x64.exe', 'c:\\rubyinstaller-devkit-3.1.1-1-x64.exe'); \
  Write-Output 'Installing Ruby + DevKit'; \
  Start-Process c:\rubyinstaller-devkit-3.1.1-1-x64.exe -ArgumentList '/verysilent /dir=C:\\ruby31' -Wait ; \
  Write-Output 'Cleaning up installation'; \
  Remove-Item c:\rubyinstaller-devkit-3.1.1-1-x64.exe -Force; \
  Write-Output 'Closing out the layer (this can take awhile)';
