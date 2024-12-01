# Prep the container
apt update -y && apt install autopoint gettext libpopt-dev -y		# Dependancies for the libexif to compile
bash -c "$(wget https://gef.blah.cat/sh -O -)"				# GEF for our gebugging with GDB

FIX_DIR="$PWD/fix/"

Incase we want to test the fixed versions, otherwise we go on with the vulnerable versions to test
if [ -n "$FIX" ];then
	LIBEXIF="libexif-0_6_19-release.tar.gz"
	EXIF="exif-0_6_19-release.tar.gz"
	mkdir "$FIX_DIR"
	cd "$FIX_DIR"
else
	LIBEXIF="libexif-0_6_18-release.tar.gz"
	EXIF="exif-0_6_18-release.tar.gz"
fi

# Setup the lab
rm -rf *exif* corpus

wget "https://github.com/libexif/libexif/archive/refs/tags/$LIBEXIF"
tar -xzf libexif*.tar.gz && mv libexif-libexif-* libexif

wget "https://github.com/libexif/exif/archive/refs/tags/$EXIF"
tar -xzf exif*.tar.gz && mv exif-exif-* exif

rm -rf corpus
git clone https://github.com/ianare/exif-samples
mv exif-samples corpus
