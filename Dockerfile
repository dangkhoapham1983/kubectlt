# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src
COPY LevelUpDevOps.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release -o /app LevelUpDevOps.csproj

# Test Stage (optional)
FROM build AS test
WORKDIR /src
RUN dotnet test

# Publish Stage
FROM build AS publish
RUN dotnet publish -c Release -o /app

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime
WORKDIR /app
COPY --from=publish /app .
ENV ConnectionStrings__MyDB ""
ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://*:80
EXPOSE 80
ENTRYPOINT ["dotnet", "LevelUpDevOps.dll"]
