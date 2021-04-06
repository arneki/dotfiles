md5h () {
  # get md5sum of hostname
  echo $(set -- $(hostname | md5sum -); echo $1)
}

containers_update () {
  # download latest visionary container and update symlink
  local LATEST_ORIGIN=$(ssh hel readlink -f /containers/stable/latest)
  echo "Syncing latest container: $LATEST_ORIGIN"
  rsync -vyhP hel:$LATEST_ORIGIN /containers/stable
  ln -sf $(basename $LATEST_ORIGIN) /containers/stable/latest
}

containers_update_overlay () {
  # update texlive overlay
  rsync -vhP hel:/containers/overlays/2021-02-17_buster_texlive_unpacked.img /containers/overlays
}

containers_cleanup () {
  # remove all containers except of the latest
  rm /containers/stable/^($(readlink /containers/stable/latest)|latest)
}

envvar_clean () {
    # clean an env variable of all entries matching a certain pattern
    # $1: name of environment variable
    # $2: pattern
    local envvar="$1"
    local pattern="$2"

    if [ -z "${${envvar}:-}" ]; then
        return
    fi

    local newval=$(eval "echo \$${envvar}" \
        | tr ':' '\n' \
        | grep -Fxv "${pattern}" \
        | tr '\n' ':' \
        | sed -e "s/:$//" -e "s/^://" -e "s/::\+/:/g")

    if [ -z "${newval}" ]; then
        unset ${envvar}
    else
        export ${envvar}="${newval}"
    fi
}

envvar_path_prepend () {
    # prepend path to environment variable
    # $1: name of environment variable
    # $2: path
    local envvar="$1"
    local path_to_add="$2"
    envvar_clean "${envvar}" "${path_to_add}"
    eval "local oldcontents=\"\${${envvar}}\"" >&2
    export ${envvar}="${path_to_add}${oldcontents:+:$oldcontents}"
}

module_reload () {
    module unload $1
    module load $1
}

zsh_host_edit () {
    # edit host-specific zsh config
    $EDITOR "$(realpath ~/.zsh)/hosts/$(md5h).zsh"
}
