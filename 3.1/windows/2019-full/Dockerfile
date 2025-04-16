FROM mcr.microsoft.com/windows:ltsc2019

ENV BUNDLE_SILENCE_ROOT_WARNING=true \
    GIT_DISCOVERY_ACROSS_FILESYSTEM=true

# When launched by user, default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]


RUN Set-ExecutionPolicy Bypass

ENV chocolateyVersion="1.4.0"
# Install Chocolatey (and essentials)
RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

RUN Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
RUN choco feature enable -n=allowGlobalConfirmation
RUN choco config set cacheLocation C:\chococache
RUN choco install git
RUN Remove-Item -Recurse -Force c:\chococache

ARG RUBY_URL=https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.4-1/rubyinstaller-3.1.4-1-x64.exe
ARG RUBY_FILE=rubyinstaller-3.1.4-1-x64.exe
ARG RUBY_DIR=c:/ruby30

# Install Ruby + Devkit
RUN Write-Output 'Downloading Ruby + DevKit'; \
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
  (New-Object System.Net.WebClient).DownloadFile(\"$env:RUBY_URL\", \"c:/$env:RUBY_FILE\")
RUN Write-Output 'Installing Ruby + DevKit'
RUN Start-Process c:/$env:RUBY_FILE -ArgumentList \"/allusers /verysilent /dir=$env:RUBY_DIR\" -Wait
RUN Write-Output 'Cleaning up installation'
RUN Remove-Item c:/$env:RUBY_FILE -Force
RUN Write-Output 'Closing out the layer (this can take awhile)'

