#!/bin/bash

set -e
wine cabal install --distdir=dist-win --bindir=.
(cd Audio/digits/; ./build.sh)

rev=$(git describe --tags)
zipfile=tttool-win32-$rev.zip
rm -f $zipfile

# Oggenc
OGGENC=oggenc2.87-1.3.4-generic.zip

mkdir -p contrib
test -e contrib/$OGGENC ||
    wget http://www.rarewares.org/files/ogg/$OGGENC -O contrib/$OGGENC
unzip -d contrib contrib/$OGGENC oggenc2.exe
mv contrib/oggenc2.exe contrib/oggenc.exe

# sox
SOXVERSION=14.4.2
SOXFILE=sox-$SOXVERSION-win32.zip

test -e contrib/$SOXFILE ||
	wget http://sourceforge.net/projects/sox/files/sox/$SOXVERSION/$SOXFILE/download -O contrib/$SOXFILE
rm -rf contrib/sox contrib/sox-$SOXVERSION
unzip -d contrib contrib/$SOXFILE
mv contrib/sox-$SOXVERSION contrib/sox

# install espeak first in wine
cp ~/.wine/drive_c/Programme/eSpeak/command_line/espeak.exe contrib/
cp -r ~/.wine/drive_c/Programme/eSpeak/espeak-data/ contrib/

zip --recurse-paths $zipfile \
	tttool.exe \
	README.md \
	Changelog.md \
	oid-decoder.html \
	example \
	example.yaml \
	Debug.yaml \
	oid-table.png \
	templates/README.md \
	templates/*.yaml \
	transcript/*.csv \
	wip/* \
	Audio/digits/*.ogg \
        contrib/oggenc.exe \
        contrib/espeak.exe \
        contrib/espeak-data \
	contrib/sox/*
echo Created $zipfile
