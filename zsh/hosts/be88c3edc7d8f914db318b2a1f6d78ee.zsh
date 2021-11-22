WANG_MODULES=/wang/environment/software/Modules/current
[ -f $WANG_MODULES/init/zsh ] && source $WANG_MODULES/init/zsh
[ -f /opt/init/modules.sh ] && emulate ksh -c 'source /opt/init/modules.sh'


powercycle () {
    module load tools-kintex7
    wafer_id=$1; shift;
    fpga_id=$1; shift;
    gres="cubex$(($wafer_id-60))"
    srun -p cubectrl --wafer $wafer_id --fpga-without-aout $fpga_id --gres $gres powercycle_hxcube.py 3
    module unload tools-kintex7
}
reconfigure () {
    module load tools-kintex7
    wafer_id=$1; shift;
    fpga_id=$1; shift;
    gres="cubex$(($wafer_id-60))"
    srun -p cubectrl --wafer $wafer_id --fpga-without-aout $fpga_id --gres $gres reconfigure_hxcube.py 3
    module unload tools-kintex7
}
enable_fpga () {
    module load tools-kintex7
    wafer_id=$1; shift;
    fpga_id=$1; shift;
    gres="cubex$(($wafer_id-60))"
    srun -p cubectrl --wafer $wafer_id --fpga-without-aout $fpga_id --gres $gres singexec hxcube_enable_fpga.py 3 --skip-bootloader
    module unload tools-kintex7
}

scube () {
    wafer_id=$1; shift;
    fpga_id=$1; shift;
    com="srun -p cube -t 20:00:00 --mem 200g -c 8 --pty --wafer $wafer_id --fpga-without-aout $fpga_id singexec $@"
    echo $com
    eval $com
}

scubel () {
    wafer_id=$1; shift;
    fpga_id=$1; shift;
    com="srun -p cube -t 1:00:00 -n 1 --pty --wafer $wafer_id --fpga-without-aout $fpga_id singexec $@"
    echo $com
    eval $com
}

get_hashes () {
    # get git hashes for every repository in current directory
    for dir in */; do 
        dir=${dir%*/}
        if git -C "$dir" rev-parse --git-dir &> /dev/null 2>&1; then
            echo "$dir $(git -C $dir rev-parse HEAD)";
        fi;
    done;
}

ccache_enable () {
    # enable ccache
    envvar_path_prepend PATH "/usr/lib/ccache"
    envvar_path_prepend SINGULARITYENV_PREPEND_PATH "/usr/lib/ccache"
    export CCACHE_DIR=/scratch/$USER/ccache
    export CCACHE_BASEDIR=$PWD
    export CCACHE_NOHASHDIR=yes
    export CCACHE_MAXSIZE="25.0G"
    export CCACHE_TEMPDIR=/tmp/$USER/ccache
    export CCACHE_LOGFILE=${CCACHE_DIR}/ccache.log
}

workdir () {
    # use current directory as new workdir
    module_reload waf
    module_reload ppu-toolchain
    pushd ${1:-$(pwd)}
    module_reload localdir
    popd
    ccache_enable
}


alias ssimulate='srun -p simulation -t 48:00:00 --mem 29g -c 8 --pty singexec'
alias sinteractive='srun -p interactive --mem 128g -c 48 --pty singexec'
alias scompile='srun -p compile -c 8 --pty singexec'
alias seinc='srun -A einc -p einc -c 32 --pty singexec'
alias seincl='srun -A einc -p einc -c 64 --pty singexec'

if [[ -z "$SINGULARITY_NAME" ]]; then
    alias vim='singexec vim'
fi
