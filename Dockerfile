FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS installer-env

COPY . /src/console-app
RUN cd /src/console-app && \
    mkdir -p /publish && \
    dotnet publish *.csproj --output /publish

#FROM mcr.microsoft.com/azure-functions/dotnet:3.0
FROM mcr.microsoft.com/dotnet/core/runtime:3.1

#####################
#PUPPETEER RECIPE
#####################
# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
#####################
#END PUPPETEER RECIPE
#####################

ENV PUPPETEER_EXECUTABLE_PATH "/usr/bin/google-chrome-stable"

WORKDIR /app
COPY --from=installer-env ["/publish", "."]

ENTRYPOINT ["dotnet", "pupputeersharp-docker.dll"]