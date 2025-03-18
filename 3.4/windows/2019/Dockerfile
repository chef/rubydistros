# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

ENV BUNDLE_SILENCE_ROOT_WARNING=true \
    GIT_DISCOVERY_ACROSS_FILESYSTEM=true

# When launched by user, default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

# Download and install .NET Framework 4.8
ADD https://go.microsoft.com/fwlink/?linkid=863265 /ndp472-kb4054530-x86-x64-allos-enu.exe
RUN C:\ndp472-kb4054530-x86-x64-allos-enu.exe /quiet /install

# Install Chocolatey (and essentials)
ADD https://chocolatey.org/install.ps1 /chocolatey_install.ps1
RUN powershell -File C:\chocolatey_install.ps1 && \
    C:\ProgramData\Chocolatey\bin\refreshenv && \
    choco feature enable -n=allowGlobalConfirmation && \
    choco config set cacheLocation C:\chococache && \
    choco upgrade chocolatey && \
    rmdir /q /s C:\chococache && \
    del C:\chocolatey_install.ps1 && \
    Write-Output "Chocolatey install complete -- closing out layer"

# Install git
RUN choco install git.install -y && \
    git config --system --add safe.directory '*' && \
    git --version

# Install Ruby + Devkit
RUN $ErrorActionPreference = 'Stop'; \
    Write-Output 'Downloading Ruby + DevKit'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.4.2-1/rubyinstaller-3.4.2-1-x64.exe', 'c:\rubyinstaller-devkit-3.4.2-1-x64.exe'); \
    Write-Output 'Installing Ruby + DevKit'; \
    Start-Process c:\rubyinstaller-devkit-3.4.2-1-x64.exe -ArgumentList '/verysilent /allusers /dir=C:\ruby34' -Wait; \
    Write-Output 'Cleaning up installation'; \
    Remove-Item c:\rubyinstaller-devkit-3.4.2-1-x64.exe -Force; \
    Write-Output 'Closing out the layer'

# Download MSYS2 dev kit, extract it and add to the PATH variable
RUN powershell -Command (New-Object System.Net.WebClient).DownloadFile('https://github.com/msys2/msys2-installer/releases/download/2025-02-21/msys2-x86_64-20250221.exe', 'c:\msys2-x86_64-20250221.exe') && \
    c:\msys2-x86_64-20250221.exe in --confirm-command --accept-messages --root C:\msys2 && \
    Remove-Item 'C:\msys2-x86_64-20250221.exe'

ENV PATH="C:\msys2;${PATH}"

# Install MSYS2 and MINGW development toolchain and enable it 
RUN ridk install 3 && \
    ridk enable