FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /var/www/html
COPY ["api/api.csproj", "api/"]
RUN dotnet restore "./api/./api.csproj"
COPY . .
WORKDIR "/var/www/html/api"
RUN dotnet build "./api.csproj" -c %BUILD_CONFIGURATION% -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./api.csproj" -c %BUILD_CONFIGURATION% -o /app/publish /p:UseAppHost=false

FROM build AS final
WORKDIR /app
# EXPOSE 8080
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "api.dll"]