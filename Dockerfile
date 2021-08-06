FROM registry.redhat.io/ubi8/dotnet-50:5.0 AS build-env

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -f netcoreapp5.0 -r rhel.8-x64 --self-contained false

# Build runtime image
FROM registry.redhat.io/ubi8/dotnet-50-runtime:5.0
COPY --from=build-env /opt/app-root/src/bin/Release/netcoreapp5.0/rhel.8-x64/publish .
ENTRYPOINT ["dotnet", "sample-api.dll"]