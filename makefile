# in bash we trust
SHELL=/bin/bash
DirRepo=${PWD}
TMUX_VERSION=2.3
PREFIX=${HOME}/local
DirTmp=${HOME}/tmux_tmp
# catch the leading number of the version 'A', where:
# gcc --version == A.B.C
GCC_VERSION=$(gcc --version | grep gcc | awk '{print $3}' | awk -F. '{print $1}')
TMUX_GZ=tmux-${TMUX_VERSION}.tar.gz

libevent:
	cp -pv ${DirRepo}/requirements/libevent-2.0.19-stable.tar.gz ${DirTmp}/.
	cd ${DirTmp}
	tar xvzf libevent-2.0.19-stable.tar.gz
	cd libevent-2.0.19-stable
	./configure --prefix=${PREFIX} --disable-shared
	make
	make install


ncurses:
	cp -pv ${DirRepo}/requirements/ncurses-5.9.tar.gz ${DirTmp}/.
	tar xvzf ncurses-5.9.tar.gz
	cd ncurses-5.9
	# check if we need to use the ncurses patch
	echo -e "\n [*] gcc version: ${GCC_VERSION}\n" \
	if [[ ${GCC_VERSION} -ge 5 ]]; then \
		echo -e "\n [*] using ncurses patch for >=gcc-5.*\n" \
		cp -r ${DirRepo}/tmux/requirements/patches ${DirTmp}/ncurses/base/MKlib_gen.sh \
	fi
	./configure --prefix=${PREFIX}
	make
	make install


tmux:
	wget \
		-O ${TMUX_GZ} \
		https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
	mkdir -p ${PREFIX} ${DirTmp}
	$(MAKE) ncurses
	$(MAKE) libevent
	#--- ok, now we build tmux-{TMUX_VERSION}
	tar xvzf ${TMUX_GZ} 
	cd tmux-${TMUX_VERSION}
	./configure \
		CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncurses" \
		LDFLAGS="-L${PREFIX}/lib -L${PREFIX}/include/ncurses -L${PREFIX}/include"
	CPPFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncurses" \
		LDFLAGS="-static -L${PREFIX}/include -L${PREFIX}/include/ncurses -L${PREFIX}/lib" \
		make
	cp tmux ${PREFIX}/bin/tmux_${TMUX_VERSION}
	rm -rf ${DirTmp}


clean:
	-rm -rf ${DirTmp} ${TMUX_GZ}

#EOF
