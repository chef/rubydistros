FROM opensuse/leap:15

# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

ENV RUBY_MAJOR 3.0
ENV RUBY_VERSION 3.0.3
ENV RUBY_DOWNLOAD_SHA256 88cc7f0f021f15c4cd62b1f922e3a401697f7943551fe45b1fdf4f2417a17a9c

RUN zypper install -y wget

RUN wget -O ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-${RUBY_VERSION}.tar.xz"
RUN echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.xz" | sha256sum -c -

# need to downgrade openssl for ruby 3.0 default build
RUN zypper rm -y openssl-3

# some of ruby's build scripts are written in ruby
# we purge system ruby later to make sure our final image uses what we just built
RUN set -ex \
	\
  && groupadd nobody -g 99 \
  && useradd nobody -c Nobody -u 99 -g 99 -s /sbin/nologin \
	&& BaseDeps=' \
    git-core \
    gcc-c++ \
    make \
    automake \
    libyaml-devel \
    ncurses-devel \
    readline-devel \
    zlib-devel \
    bison \
    patch \
    libtool \
    automake \
    curl \
    xz \
    which \
    libopenssl-1_0_0-devel \
    libopenssl1_0_0 \
    openssl-1_0_0 \
    hostname \
	' \
	&& zypper install -y $BaseDeps ruby \
	\
	&& mkdir -p /usr/src/ruby \
	&& tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.xz \
	\
	&& cd /usr/src/ruby \
	\
# hack in "ENABLE_PATH_CHECK" disabling to suppress:
#   warning: Insecure world writable dir
	&& { \
		echo '#define ENABLE_PATH_CHECK 0'; \
		echo; \
		cat file.c; \
	} > file.c.new \
	&& mv file.c.new file.c \
	\
	&& autoconf \
	&& ./configure \
		--disable-install-doc \
		--enable-shared \
	&& make -j "$(nproc)" \
	&& make install \
	\
	&& zypper remove -y ruby \
	&& cd / \
	&& rm -r /usr/src/ruby \
# rough smoke test
RUN ruby --version && gem --version && bundle --version

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
# path recommendation: https://github.com/bundler/bundler/pull/6469#issuecomment-383235438
ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH
# adjust permissions of a few directories for running "gem install" as an arbitrary user
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"
# (BUNDLE_PATH = GEM_HOME, no need to mkdir/chown both)

CMD [ "irb" ]
