FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /var/www/html
COPY ["webapi/webapi.csproj", "webapi/"]
RUN dotnet restore "./webapi/./webapi.csproj"
COPY . .
WORKDIR "/var/www/html/webapi"
RUN dotnet build "./webapi.csproj" -c %BUILD_CONFIGURATION% -o /var/www/html/webapi/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./webapi.csproj" -c %BUILD_CONFIGURATION% -o /var/www/html/webapi/publish /p:UseAppHost=false

FROM build AS final
WORKDIR /var/www/html/webapi
# EXPOSE 8080
COPY --from=publish /var/www/html/webapi/publish .
ENTRYPOINT ["dotnet", "webapi.dll"]
