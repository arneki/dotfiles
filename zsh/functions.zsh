md5h () {
  # get md5sum of hostname
  echo $(set -- $(hostname | md5sum -); echo $1)
}
