#!/usr/bin/env bash

# Optional variables defaults
[ -z "${PATH_HOME}" ] && export PATH_HOME="/home/${HOST_USER_NAME}"
[ -z "${USER_PASSWORD}" ] && export USER_PASSWORD="${HOST_USER_NAME}"
[ -z "${USER_SHELL}" ] && export USER_SHELL="/bin/bash"

if ! getent passwd ${HOST_USER_NAME} > /dev/null 2>&1
  then
    echo "Creating user ${HOST_USER_NAME}:${HOST_GROUP_NAME}"

    # Create home directory if not exists
    __CREATE_PATH_HOME__=false
    if [ -d "${PATH_HOME}" ]; then
      __CREATE_PATH_HOME__=true
      mkdir -p "${PATH_HOME}"
    fi

    # Add Group
    groupadd -g ${HOST_GROUP_ID} -r ${HOST_GROUP_NAME}

    # Add User
    useradd -r \
      -u ${HOST_USER_ID} -g ${HOST_GROUP_ID} \
      -d ${PATH_HOME} \
      -s ${USER_SHELL} \
      -c "Host User ${HOST_USER_NAME}" \
      ${HOST_USER_NAME}

    # Set User Password
    echo ${HOST_USER_NAME}:${USER_PASSWORD} | chpasswd

    # Add user to group
    usermod -a -G sudo ${HOST_USER_NAME}

    # Sudo without password
    echo "#!/usr/bin/env bash" > /bin/visudoset
    echo "echo \"${HOST_USER_NAME} ALL=(ALL) NOPASSWD: ALL\" >> \$1" >> /bin/visudoset
    chmod a+x /bin/visudoset
    EDITOR=visudoset visudo
    rm -f /bin/visudoset

    # Home directory owner
    ${__CREATE_PATH_HOME__} && chown -v ${HOST_USER_NAME}:${HOST_GROUP_NAME} ${PATH_HOME}
  fi

# Run as User
sudo -E -u ${HOST_USER_NAME} "$@"
