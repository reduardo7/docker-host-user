# docker-host-user: Host User &amp; Group

Create containers with current/custom user and group. Ideal for development environments.

You can use this image to run your app with your current/custom user and group.

## Start

```bash
docker run --rm -i -t \
  --name my-user-test \
  -e HOST_USER_NAME=$USERNAME \
  -e HOST_USER_ID=$UID \
  -e HOST_GROUP_NAME=$(id -g -n $USERNAME || echo $USERNAME) \
  -e HOST_GROUP_ID=$(id -g $USERNAME) \
  reduardo7/docker-host-user \
  echo "User: \$USERNAME"
```

## Usage

You can use this image as a base image (`FROM reduardo7/docker-host-user`) to run your app with your current/custom user and group.

### Sample Dockerfile

```Dockerfile
FROM reduardo7/docker-host-user

ENV HOST_USER_NAME 'foo'
...

CMD /init-user.sh echo 'hola'
```

## Environment Variables

### HOST_USER_NAME

**User name**. You can use `$USERNAME` to get current *user name*.

### HOST_USER_ID

**User ID**. You can use `$UID` to get current *user ID*.

### HOST_GROUP_NAME

**User group name**. You can use `$(id -g -n $USERNAME)` to get current *user group name*.

### HOST_GROUP_ID

**User group ID**. You can use `$(id -g $USERNAME)` to get current *user group ID*.

### USER_SHELL

**Optional**. Default value: `/bin/bash`.

User shell.

### USER_PASSWORD

**Optional**. Default value: `${HOST_USER_NAME}`.

User password.

### PATH_HOME

**Optional**. Default value: `/home/${HOST_USER_NAME}`.

User home path.

## docker-compose

`docker-compose.yml` example:

```yml
version: "2"

services:
  app:
    image: reduardo7/docker-host-user
    environment:
      # Required:
      HOST_USER_NAME: "u${USERNAME}"
      HOST_USER_ID: "3003"
      HOST_GROUP_NAME: "g${USERNAME}"
      HOST_GROUP_ID: "7007"
      # Optional:
      USER_SHELL: "/bin/bash" # Default: /bin/bash
      USER_PASSWORD: "123456789" # Default: ${HOST_USER_NAME}
      PATH_HOME: "/home/myuserhome" # Default: /home/${HOST_USER_NAME}
```
