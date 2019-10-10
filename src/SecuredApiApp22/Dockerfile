FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443


FROM oauth2apiexample/base-build AS build
WORKDIR /src
RUN dotnet publish SecuredApiApp22 -c Release -o out --no-restore --no-build

FROM base AS final
WORKDIR /app
COPY --from=build /src/out .
ENTRYPOINT ["dotnet", "SecuredApiApp22.dll"]


