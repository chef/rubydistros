FROM mcr.microsoft.com/windows/servercore:ltsc2019

ENV BUNDLE_SILENCE_ROOT_WARNING=true \
    GIT_DISCOVERY_ACROSS_FILESYSTEM=true

# When launched by user, default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

# latest choco via PowerShell on windows2019 requires .NET, Download and install .NET Framework 4.8
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

# Install Git
RUN choco install git.install -y
RUN git config --system --add safe.directory '*'
RUN git --version  

# Install Ruby + DevKit using Chocolatey
RUN choco install ruby --version=3.4.2.1 -y

# Update PATH with Ruby and MSYS2 binaries locations
RUN powershell -Command " \
    [Environment]::SetEnvironmentVariable('PATH', 'C:\tools\ruby\bin;C:\tools\msys64\usr\bin;C:\tools\msys64\mingw64\bin;' + $env:PATH, [EnvironmentVariableTarget]::Machine); \
    $env:PATH = 'C:\tools\ruby\bin;C:\tools\msys64\usr\bin;C:\tools\msys64\mingw64\bin;' + $env:PATH; \
    Write-Output 'PATH updated';"

# Permanently set the PATH for future commands
ENV PATH="C:\\tools\\ruby\\bin;C:\\tools\\msys64\\usr\\bin;C:\\tools\\msys64\\mingw64\\bin;${PATH}"

# Install bundler
RUN powershell -Command " \
    gem install bundler -v '~> 2.3'; \
    bundler --version"

# Verify installation
RUN powershell -Command " \
    ruby -v; \
    gem -v; \
    bundler -v"