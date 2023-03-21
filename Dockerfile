FROM nvidia/cuda:12.1.0-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

# number of CPU's use for compilation
ARG CPUS=16

# install deps
RUN apt-get update -qq && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  nasm \
  libunistring-dev \
  libaom-dev \
  libx265-dev \
  libx264-dev \
  libnuma-dev \
  libfdk-aac-dev \
  libc6 \
  libc6-dev \
  unzip \
  libnuma1

# compile ffmpeg
RUN mkdir -p ~/ffmpeg_sources ~/bin && \
  cd ~/ffmpeg_sources && \
  wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
  tar xjvf ffmpeg-snapshot.tar.bz2 && \
  cd ffmpeg && \
  PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
    --bindir="$HOME/bin" \
    --enable-gpl \
    --enable-gnutls \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree && \
  PATH="$HOME/bin:$PATH" make -j $CPUS && \
  make install && \
  hash -r

# install ffmpeg-nvidia adapter
RUN mkdir ~/nv && cd ~/nv && \
  git clone https://github.com/FFmpeg/nv-codec-headers.git && \
  cd nv-codec-headers && make install

# compile ffmpeg with cuda
RUN cd ~/nv && \
  git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/ && \
  cd ffmpeg && \
  ./configure \
    --enable-nonfree \
    --enable-cuda-nvcc \
    --enable-libnpp \
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 \
    --disable-static \
    --enable-gnutls \
    --enable-shared && \
  make -j $CPUS && \
  make install

CMD ["bash"]