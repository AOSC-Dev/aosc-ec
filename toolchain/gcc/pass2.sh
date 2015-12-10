source toolchain/gcc/ver.sh
source toolchain/libc/$AOSC_EC_LIBC/ver.sh

fprint="$(mktemp)"

echo "$PWD"/out/tools $AOSC_EC_ARCH $AOSC_EC_LIBC $AOSC_EC_TRIPLET "$PWD"/out/sysroot > $fprint
echo musl $musl_ver >> $fprint
echo c,c++ >> $fprint

echo $TARGET_CFLAGS_MACHINE >> $fprint
echo $TARGET_CXXFLAGS_MACHINE >> $fprint

if [ "$AOSC_EC_ARCH" = "arm" ]; then
	grep '^CONFIG_ARCH_ARM_FLOAT_ABI' ./.config >> $fprint
	grep '^CONFIG_ARCH_ARM_FPU' ./.config >> $fprint
fi

rm -rf $PWD/out/build/gcc-pass2
mkdir -p $PWD/out/build/gcc-pass2

utils/build_cache/cache_build gcc-pass2-$gcc_ver-$AOSC_EC_TRIPLET $fprint "$PWD"/out/build/gcc-pass2/destdir toolchain/gcc/pass2_build.sh

rm $fprint

cp -r "$PWD"/out/build/gcc-pass2/destdir/"$PWD"/out/* "$PWD"/out/
