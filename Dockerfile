# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

MAINTAINER Samuel Barrera

LABEL version="1.0"
LABEL description="Docker image for CI of .NET Project"

RUN apt-get clean
RUN apt-get -y update
RUN apt-get -y install zip

# Install web workload:
RUN Invoke-WebRequest -UseBasicParsing https://download.visualstudio.microsoft.com/download/pr/100196686/e64d79b40219aea618ce2fe10ebd5f0d/vs_BuildTools.exe -OutFile vs_BuildTools.exe; `  
    Start-Process vs_BuildTools.exe -ArgumentList  '--add', 'Microsoft.VisualStudio.Workload.WebBuildTools', '--quiet', '--norestart', '--nocache' -NoNewWindow -Wait;

# Install WebDeploy
RUN Install-PackageProvider -Name chocolatey -RequiredVersion 2.8.5.130 -Force; `  
    Install-Package -Name webdeploy -RequiredVersion 3.6.0 -Force; `
    Install-Package -Name microsoft-build-tools -RequiredVersion 15.0.26228.0 -Force; `
    Install-Package -Name netfx-4.5.2-devpack -RequiredVersion 4.5.5165101 -Force; `
    Install-Package nuget.commandline -RequiredVersion 3.5.0 -Force;

ENV NUGET_PATH="C:\Chocolatey\lib\NuGet.CommandLine.3.5.0\tools" `
    MSBUILD_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin"

RUN $env:PATH = $env:NUGET_PATH + ';' + $env:MSBUILD_PATH + ';' + $env:PATH; `  
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

#RUN dotnet tool install -g dotnet-serve
#ENV PATH="${PATH}:/root/.dotnet/tools"
#RUN dotnet tool install -g dotnetsay
#RUN dotnetsay
#RUN dotnet tool install -g Amazon.Lambda.Tools
#RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
#RUN unzip awscli-bundle.zip
#RUN ./awscli-bundle/install -b ~/bin/aws