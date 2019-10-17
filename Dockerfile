FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0.100-alpine AS build
WORKDIR /src
COPY ./Toss.Client/Toss.Client.csproj ./Toss.Client/
COPY ./Toss.Server/Toss.Server.csproj ./Toss.Server/
COPY ./Toss.Shared/Toss.Shared.csproj ./Toss.Shared/
COPY ./Toss.Tests/Toss.Tests.csproj ./Toss.Tests/
COPY ./Toss.Tests.E2E/Toss.Tests.E2E.csproj ./Toss.Tests.E2E/
COPY ./Toss.sln ./
RUN dotnet restore ./Toss.sln
COPY ./Toss.Client ./Toss.Client
COPY ./Toss.Server ./Toss.Server
COPY ./Toss.Shared ./Toss.Shared
COPY ./Toss.Tests ./Toss.Tests
RUN dotnet publish Toss.Server/Toss.Server.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "Toss.Server.dll"]
