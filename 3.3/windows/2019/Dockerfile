FROM mcr.microsoft.com/windows/servercore:ltsc2019

ENV BUNDLE_SILENCE_ROOT_WARNING=true \
    GIT_DISCOVERY_ACROSS_FILESYSTEM=true

# When launched by user, default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

# Download and install .NET Framework 4.8
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019
ADD https://go.microsoft.com/fwlink/?linkid=863265 /ndp472-kb4054530-x86-x64-allos-enu.exe
RUN C:\ndp472-kb4054530-x86-x64-allos-enu.exe /quiet /install

# Install Chocolatey (and essentials)
ADD https://chocolatey.org/install.ps1 /chocolatey_install.ps1
RUN powershell -File C:\chocolatey_install.ps1
RUN C:\ProgramData\Chocolatey\bin\refreshenv -and \
  choco feature enable -n=allowGlobalConfirmation -and \
  choco config set cacheLocation C:\chococache -and \
  choco upgrade chocolatey -and \
  choco install git -and \
  rmdir /q /s C:\chococache -and \
  del C:\chocolatey_install.ps1 -and \
  echo "Chocolatey install complete -- closing out layer"

# Install Ruby + Devkit
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Write-Output 'Downloading Ruby + DevKit'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.2-1/rubyinstaller-devkit-3.3.2-1-x64.exe', 'c:\\rubyinstaller-devkit-3.3.2-1-x64.exe'); \
    Write-Output 'Installing Ruby + DevKit'; \
    Start-Process c:\rubyinstaller-devkit-3.3.2-1-x64.exe -ArgumentList '/verysilent /dir=C:\\ruby33' -NoNewWindow ; \
    Write-Output 'Cleaning up installation'; \
    Remove-Item c:\rubyinstaller-devkit-3.3.2-1-x64.exe -Force -ErrorAction SilentlyContinue; \
    Write-Output 'Closing out the layer (this can take awhile)'; \
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\\ruby33\\bin', [EnvironmentVariableTarget]::Machine)
# Reopen a new shell to pick up the new PATH
SHELL ["cmd", "/S", "/C"]
# Initialize and install Ruby DevKit
RUN cd C:\RubyDevKit
    ruby dk.rb init
    ruby dk.rb install
    devkitvars.bat
# Install Bundler
RUN gem install bundler
# Verify installation
RUN ruby -v
RUN bundler -v
