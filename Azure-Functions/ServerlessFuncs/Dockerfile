#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/azure-functions/dotnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY ["ServerlessFuncs.csproj", ""]
RUN dotnet restore "./ServerlessFuncs.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ServerlessFuncs.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ServerlessFuncs.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV AzureWebJobsScriptRoot=/app