#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-bluemsx"
rp_module_desc="MSX/MSX2 emu - blueMSX port for libretro"
rp_module_help="ROM Extensions: .rom .mx1 .mx2 .col .dsk .zip\n\nCopy your MSX/MSX2 roms to $romdir/msx"
rp_module_section="main"

function sources_lr-bluemsx() {
    gitPullOrClone "$md_build" https://github.com/libretro/blueMSX-libretro.git
}

function build_lr-bluemsx() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/bluemsx_libretro.so"
}

function install_lr-bluemsx() {
    md_ret_files=(
        'bluemsx_libretro.so'
        'README.md'
        'system/bluemsx/Databases'
        'system/bluemsx/Machines'
    )
}

function configure_lr-bluemsx() {
    mkRomDir "msx"
    ensureSystemretroconfig "msx"

    cp -rv "$md_inst/"{Databases,Machines} "$biosdir/"
    chown -R $user:$user "$biosdir/"{Databases,Machines}

    wget -q -O- "$__archive_url/bluemsxroms.tar.gz" | tar -xvz -C "$biosdir/Machines/Shared Roms/"

    addSystem 1 "$md_id" "msx" "$md_inst/bluemsx_libretro.so"
}
