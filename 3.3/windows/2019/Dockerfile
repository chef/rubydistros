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
  rmdir /q /s C:\chococache -and \
  del C:\chocolatey_install.ps1 -and \
  Write-Output "Chocolatey install complete -- closing out layer"

RUN choco install git.install -version 2.35.1 -y
RUN git --version  

# Install Ruby + Devkit
RUN powershell -Command \
  $ErrorActionPreference = 'Stop'; \
  Write-Output 'Downloading Ruby + DevKit'; \
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
  (New-Object System.Net.WebClient).DownloadFile('https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.3-1/rubyinstaller-3.3.3-1-x64.exe', 'c:\\rubyinstaller-devkit-3.3.3-1-x64.exe'); \
  Write-Output 'Installing Ruby + DevKit'; \
  Start-Process c:\rubyinstaller-devkit-3.3.3-1-x64.exe -ArgumentList '/verysilent /allusers /dir=C:\\ruby33' -Wait ; \
  Write-Output 'Cleaning up installation'; \
  Remove-Item c:\rubyinstaller-devkit-3.3.3-1-x64.exe -Force; \
  Write-Output 'Closing out the layer';

# Download MSYS2 dev kit, extract it and add to the PATH variable

RUN powershell -Command (New-Object System.Net.WebClient).DownloadFile('https://github.com/msys2/msys2-installer/releases/download/2024-05-07/msys2-x86_64-20240507.exe', 'c:\\msys2-x86_64-20240507.exe'); \
   .\msys2-x86_64-20240507.exe in --confirm-command --accept-messages --root C:\msys2 ; \
   [Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\msys2', [EnvironmentVariableTarget]::Machine); \
   Remove-Item 'C:\msys2-x86_64-20240507.exe'
RUN ridk install 3
RUN ridk enable

#RUN ridk exec pacman -Syu --noconfirm
#RUN ridk exec rm -r C:\msys2-x86_64-20240507.exe/var/cache/pacman/pkg
 

   # pacman fails with EXDEV error after download when /var/cache/pkg is bind mounted into the container.
   # Therefore mount /var/cache directory an let pacman create the pkg directory.
# RUN ridk exec rm -r c:/msys2-x86_64-20240507/var/cache/pacman/pkg
   
   # Import the git repository and unpack it in /build
#WORKDIR /build
#COPY gitrepo .git/
#RUN dir
#RUN git checkout -f
   
   # Install required rubygems
#RUN gem install bundler --no-doc
#RUN bundle