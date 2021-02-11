#/bin/sh
set -e

ROOT=$(pwd)

echo "BUILDING LLVM"
echo "Make sure directories 'build' and 'install' do not exist."
mkdir build
mkdir install
cd build
# both llvm's are the same, but the rt-lib has different instrumentation.
# there is a lot of dummy work here. this should be improved.
cmake -G Ninja ../fineibt_llvm/llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS='clang;lld' -DLLVM_TARGETS_TO_BUILD='X86' -DCMAKE_INSTALL_PREFIX=$ROOT/install/llvm-fine -DLLVM_ENABLE_LTO='Off' -DLLVM_BINUTILS_INCDIR=/usr/include
ninja install
mkdir compiler-rt-build
mkdir $ROOT/install/llvm-fine/lib/clang/12.0.0/share
touch $ROOT/install/llvm-fine/lib/clang/12.0.0/share/cfi_blacklist.txt
cd compiler-rt-build
export CC=$ROOT/install/llvm-fine/bin/clang
export CXX=$ROOT/install/llvm-fine/bin/clang++
export CFLAGS="-fcf-protection=fine"
cmake -G Ninja ../../fineibt_llvm/compiler-rt -DLLVM_CONFIG_PATH=$ROOT/install/llvm-fine/bin/llvm-config -DCMAKE_INSTALL_PREFIX=$ROOT/install/llvm-fine/lib/clang/12.0.0/
ninja install
cd ../../

echo "BUILDING FINE-GRAINED GLIBC"
unset CFLAGS
export CC=$ROOT/install/llvm-fine/bin/clang
export CXX=$ROOT/install/llvm-fine/bin/clang++
cd fineibt_glibc
rm -rf build
mkdir build
cd build
../configure CC=$ROOT/install/llvm-fine/bin/clang --prefix=$ROOT/install/glibc-fine/ --with-clang --disable-werror --disable-float128 --with-lld --with-default-link --disable-multi-arch --enable-bind-now --enable-cet --enable-fineibt --verbose --enable-fixedr11
make -j8
make install
