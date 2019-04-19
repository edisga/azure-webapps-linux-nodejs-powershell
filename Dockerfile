FROM node
RUN mkdir /code
WORKDIR /code
ADD package.json /code/
RUN npm install
ADD . /code/

# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg apt-transport-https dialog \
        && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list' \
        && apt-get update \
	&& apt-get install -y --no-install-recommends openssh-server powershell \
	&& echo "$SSH_PASSWD" | chpasswd 

COPY sshd_config /etc/ssh/
COPY init.ps1 /usr/local/bin/
RUN chmod +x /opt/microsoft/powershell/6/pwsh

EXPOSE 2222 3000
ENV PORT 3000

ENTRYPOINT ["/opt/microsoft/powershell/6/pwsh",  "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';", "/usr/local/bin/init.ps1"]