#docker run --rm -it -v "$PWD:/fuzz" --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --platform linux/amd64 --name fuzzing aflplusplus/aflplusplus:latest
#
# To be able to look at the code through our LSP we need to run `compiledb -n make` in the directories from our host.

if [ -n "$FIX" ];then
	FUZZ_DIR="/fuzz/fix"
else
	FUZZ_DIR="/fuzz"
fi

# Env for the Library
# Change me
TARGET_LIB_DIR="$FUZZ_DIR/libexif"
BUILD_LIB_DIR="$TARGET_LIB_DIR/install"

# Env for the binary
TARGET_BIN_DIR="$FUZZ_DIR/exif"
BUILD_BIN_DIR="$TARGET_BIN_DIR/install"
TARGET_BIN_BINARY="$BUILD_BIN_DIR/bin/exif"

# Seed/out for our fuzzer
SEEDS="$FUZZ_DIR/corpus"
OUT_DIR="$FUZZ_DIR/out"


# AFL env
AFL_DIR="/AFLplusplus"
AFL_CC="$AFL_DIR/afl-clang-lto"
AFL_FUZZ="$AFL_DIR/afl-fuzz"


# Moving to the library directory to clean and build
cd "$TARGET_LIB_DIR"

# Cleanup
echo -e "\nCleaning up the lib\n"
rm -rf "$BUILD_LIB_DIR"
make clean
mkdir "$BUILD_LIB_DIR"

echo -e "\nCleaning up the cli\n"
rm -rf "$BUILD_BIN_DIR"
make clean
mkdir "$BUILD_BIN_DIR"

# Building the library
echo -e "\nBuilding the library\n"
autoreconf -i
if [ -n "$DEBUG" ];then
	./configure --prefix="$BUILD_LIB_DIR" && make && make install
else
	CC="$AFL_CC" CXX="$AFL_CC++" "./configure" --prefix="$BUILD_LIB_DIR" && make && make install
fi

# Moving to the cli directory to clean and build
cd "$TARGET_BIN_DIR"

# Building the cli
echo -e "\nBuilding the cli\n"
autoreconf -i
if [ -n "$DEBUG" ];then
	./configure --prefix="$BUILD_BIN_DIR" PKG_CONFIG_PATH="$BUILD_LIB_DIR/lib/pkgconfig" && make && make install
else
	CC="$AFL_CC" CXX="$AFL_CC++" ./configure --prefix="$BUILD_BIN_DIR" PKG_CONFIG_PATH="$BUILD_LIB_DIR/lib/pkgconfig" && make && make install
fi

# Running the fuzz
if [ -n "$DEBUG" ];then
	echo -e "\nDone\n"
else
	echo -e "\nStarting the Fuzzing\n"
	"$AFL_FUZZ" -i "$SEEDS" -o "$OUT_DIR" -s 333 -m none -- "$TARGET_BIN_BINARY" @@
fi
