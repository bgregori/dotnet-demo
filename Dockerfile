FROM registry.redhat.io/ubi8/dotnet-31:3.1 AS build-env

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -f netcoreapp3.1 -r rhel.8-x64 --self-contained false

# Build runtime image
FROM registry.redhat.io/ubi8/dotnet-31-runtime:3.1
COPY --from=build-env /opt/app-root/src/bin/Release/netcoreapp3.1/rhel.8-x64/publish .
ENTRYPOINT ["dotnet", "sample-api.dll"]