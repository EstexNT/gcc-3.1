#!/usr/bin/env bash

wget https://ftp.gnu.org/gnu/gcc/gcc-3.1.tar.gz
tar xzf gcc-3.1.tar.gz
rm gcc-3.1.tar.gz

cd gcc-3.1

cd libiberty
./configure \
	--target=sh-elf \
	--prefix=/opt/cross \
	--with-endian-little \
	--with-gnu-as \
	--disable-gprof \
	--disable-gdb \
	--disable-werror \
	--host=i386-pc-linux \
	--build=i386-pc-linux

cd ../gcc
./configure \
	--target=sh-elf \
	--prefix=/opt/cross \
	--with-endian-little \
	--with-gnu-as \
	--disable-gprof \
	--disable-gdb \
	--disable-werror \
	--host=i386-pc-linux \
	--build=i386-pc-linux

cd ..

sed -i -- 's/include <varargs.h>/include <stdarg.h>/g' **/*.c

patch -u -p1 include/obstack.h -i ../obstack31.h.patch
patch -u -p1 gcc/cp/decl.c -i ../decl31.c.patch
patch -u -p1 gcc/varasm.c -i ../varasm.c.patch

# -m32 breaks 
make -C libiberty/ CFLAGS="-std=gnu89 -static"
make -C gcc/ -j cpp cc1 xgcc cc1plus g++ CFLAGS="-std=gnu89 -static"


