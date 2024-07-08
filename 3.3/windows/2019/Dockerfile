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
  echo "Chocolatey install complete -- closing out layer"

# Install Ruby and Bundler using Chocolatey
#RUN cmd.exe /c choco install ruby -y
#RUN cmd.exe /c choco install bundler -y

# Set the PATH environment variable to include Ruby's bin directory
#ENV PATH="C:\\tools\\ruby33\\bin;${PATH}"  

# Install Ruby + Devkit
# Download, install, and clean up Ruby + DevKit
RUN powershell -Command \
    #$ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    $installerUrl = 'https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.3-1/rubyinstaller-devkit-3.3.3-1-x64.exe'; \
    $installerPath = 'C:\\rubyinstaller-devkit-3.3.3-1-x64.exe'; \
    $installDir = 'C:\\ruby33'; \
    Write-Output 'Downloading Ruby + DevKit'; \
    try { \
        (New-Object System.Net.WebClient).DownloadFile($installerUrl, $installerPath); \
        Write-Output 'Download completed successfully.'; \
    } catch { \
        Write-Error 'Failed to download Ruby + DevKit: $_'; \
        exit 1; \
    }; \
    Write-Output 'Installing Ruby + DevKit'; \
    try { \
        Start-Process -FilePath $installerPath -ArgumentList '/verysilent /dir=C:\\ruby33' -Wait -NoNewWindow; \
        Write-Output 'Installation completed successfully.'; \
    } catch { \
        Write-Error 'Failed to install Ruby + DevKit: $_'; \
        exit 1; \
    }; \
    Write-Output 'Cleaning up installation files'; \
    try { \
        Remove-Item -Path $installerPath -Force; \
        Write-Output 'Cleanup completed successfully.'; \
    } catch { \
        Write-Error 'Failed to clean up installation files: $_'; \
        exit 1; \
    }; \
    Write-Output 'Setup completed. Closing out the layer.'
  
  
    
