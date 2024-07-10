# Use a Windows Server Core base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set shell to PowerShell
SHELL ["powershell", "-Command"]

# Download and install Ruby
RUN Invoke-WebRequest -Uri https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.1.tar.gz -OutFile C:\ruby.zip; \
    Expand-Archive -Path C:\ruby.zip -DestinationPath C:\; \
    Remove-Item C:\ruby.zip -Force; \
    Move-Item -Path C:\ruby-* C:\ruby

# Add Ruby to PATH
RUN setx /M PATH $($Env:PATH + ';C:\ruby\bin')

# Show installed Ruby version
RUN ruby --version

# Download and install Ruby DevKit
RUN Invoke-WebRequest -Uri https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.3-1/rubyinstaller-3.3.3-1-x64.exe -OutFile C:\devkit.zip; \
    Expand-Archive -Path C:\devkit.zip -DestinationPath C:\devkit; \
    Remove-Item C:\devkit.zip -Force; \
    C:\devkit\devkitvars.bat

# Configure Ruby DevKit
RUN cd C:\ruby && \
    ruby dk.rb init && \
    ruby dk.rb install
