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
