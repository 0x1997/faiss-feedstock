#!/usr/bin/env bash
set -e -x

HEADER_DIR="${PREFIX}/include/faiss"
LIB_DIR="${PREFIX}/lib"

PYTHON_INC=$($PYTHON -c "import distutils.sysconfig; print(distutils.sysconfig.get_python_inc())")
NUMPY_INC="${SP_DIR}/numpy/core/include"

sed "s|^PYTHONCFLAGS.*$|PYTHONCFLAGS=-I${PYTHON_INC} -I${NUMPY_INC}|g" \
    example_makefiles/makefile.inc.Linux >makefile.inc
make $MAKEFLAGS \
    BLASLDFLAGS="-Wl,--no-as-needed -L$LIB_DIR -lmkl_intel_ilp64 -lmkl_core -lmkl_gnu_thread -ldl -lpthread" \
    BLASCFLAGS="-DFINTEGER=long" \
    libfaiss.so py

mkdir -p "$HEADER_DIR"
cp -a *.h "$HEADER_DIR"
install libfaiss.so "$LIB_DIR"
install _swigfaiss.so *.py "$SP_DIR"
install "$RECIPE_DIR/faiss.pc" "$PKG_CONFIG_PATH"
