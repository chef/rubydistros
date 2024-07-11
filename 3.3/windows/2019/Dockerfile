
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Download base ruby
RUN powershell \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.3-1/rubyinstaller-3.3.3-1-x64.exe -Outfile rubyinstaller.exe
# Download Inno Setup    
RUN powershell \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest http://www.jrsoftware.org/download.php/is.exe -Outfile inno-setup.exe

# Install Inno Setup
RUN cmd /c inno-setup.exe /verysilent /allusers
RUN powershell [Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';c:/Program Files (x86)/Inno Setup 6', 'Machine')
RUN iscc --version || (exit 0)

# Install base ruby and initialize Devkit
RUN powershell -Command Start-Process c:\rubyinstaller.exe -ArgumentList '/verysilent /allusers /dir=C:\\ruby33' -Wait
RUN powershell $env:PATH = [Environment]::GetEnvironmentVariable('PATH','Machine'); \
    $env:RUBYOPT = [Environment]::GetEnvironmentVariable('RUBYOPT','Machine')
RUN ruby --version
#RUN ridk install 1

# Download git
RUN powershell \
    Invoke-WebRequest 'https://github.com/git-for-windows/git/releases/download/v2.12.2.windows.2/MinGit-2.12.2.2-64-bit.zip' -OutFile MinGit.zip
    Expand-Archive c:\MinGit.zip -DestinationPath c:\MinGit; \
$env:PATH = $env:PATH + ';C:\MinGit\cmd\;C:\MinGit\cmd'; \
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH

# Install git

RUN git --version


RUN ridk enable

# pacman fails with EXDEV error after download when /var/cache/pkg is bind mounted into the container.
# Therefore mount /var/cache directory an let pacman create the pkg directory.
RUN ridk exec rm -r c:/ruby24-x64/msys64/var/cache/pacman/pkg

# Import the git repository and unpack it in /build
WORKDIR /build
COPY gitrepo .git/
RUN dir
RUN git checkout -f

# Install required rubygems
RUN gem install bundler --no-doc
RUN bundle

WORKDIR /build/docker
CMD rake
