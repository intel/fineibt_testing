ROOT=$(pwd)
set -e
cd example
rm -rf build
mkdir build
cd build

export GLIBC_TUNABLES=glibc.cpu.x86_ibt=off:glibc.cpu.x86_shstk=off

CCFINE=$ROOT/install/llvm-fine/bin/clang
OBJFINE="${CCFINE} -O0 -c -fPIC -fcf-protection=fine -ffixed-r11"
DSOFINE="${CCFINE} -O0 -shared -fcf-protection=fine -Wl,-z,relro,-z,now,-z,force-ibt -fuse-ld=lld -rtlib=compiler-rt --sysroot=${ROOT}/install/glibc-fine/"
APPFINE="${CCFINE} -O0 -fcf-protection=fine -ffixed-r11 -Wl,-z,relro,-z,now,-z,force-ibt,-dynamic-linker=${ROOT}/install/glibc-fine/lib/ld-2.29.so --rtlib=compiler-rt -L./ -lbsortfine -fuse-ld=lld --sysroot=${ROOT}/install/glibc-fine/ "
OBJCOARSE="${CCFINE} -O0 -c -fPIC -fcf-protection=full --rtlib=compiler-rt"
DSOCOARSE="${CCFINE} -O0 -shared -fcf-protection=full -Wl,-z,force-ibt -fuse-ld=lld -rtlib=compiler-rt --sysroot=${ROOT}/install/glibc-fine/ "
OBJNOCFI="${CCFINE} -O0 -c -fPIC --rtlib=compiler-rt"
DSONOCFI="${CCFINE} -O0 -shared -fuse-ld=lld -rtlib=compiler-rt --sysroot=${ROOT}/install/glibc-fine/ "


echo "building DSOs"
echo "- Bsort lib fine"
${OBJFINE} -o bsort_fine_lib.o ../bsort/bsortlib.c
${DSOFINE} -o libbsortfine.so bsort_fine_lib.o

#Applications
echo "- Bsort app fine"
${APPFINE} -c -o bsort_fine1.o ../bsort/bsort.c
${APPFINE} -c -o bsort_fine2.o ../bsort/bsort2.c
${APPFINE} -o bsort_fine bsort_fine1.o bsort_fine2.o

echo "building Testbits"
${OBJFINE} -o foofinelib.o ../cetbits/foo.c
${DSOFINE} -o libfoofine.so foofinelib.o
${OBJCOARSE} -o foocoarselib.o ../cetbits/foo.c
${DSOCOARSE} -o libfoocoarse.so foocoarselib.o
${OBJNOCFI} -o foonocfilib.o ../cetbits/foo.c
${DSONOCFI} -o libfoonocfi.so foonocfilib.o

${CCFINE} -O2 -g -fcf-protection=fine -ffixed-r11 -c -o mainfine.o ../cetbits/main.c
${CCFINE} -O2 -g -fcf-protection=fine -ffixed-r11 -c -o test.o ../cetbits/test.S -include cet.h -DASSEMBLER -I${ROOT}/install/llvm-fine/lib/clang/12.0.0/include
${CCFINE} -O2 -g -fcf-protection=fine -ffixed-r11 -Wl,-z,relro,-z,now,-z,force-ibt,-dynamic-linker=${ROOT}/install/glibc-fine/lib/ld-2.29.so --rtlib=compiler-rt -L./ -L${ROOT}/install/glibc-fine/lib -lfoofine -fuse-ld=lld --sysroot=${ROOT}/install/glibc-fine/ mainfine.o test.o -o testbits -ldl

echo "Building CET test"
${CCFINE} -o main.o -c ../break/main.c -fcf-protection=branch
${CCFINE} -o br.o -c ../break/br.S -fcf-protection=branch
${CCFINE} -o nobr.o -c ../break/nobr.S -fcf-protection=branch
${APPFINE} -o breaks main.o br.o
${APPFINE} -o nobreaks main.o nobr.o
