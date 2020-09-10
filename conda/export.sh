docker run -v conda:/home/jovyan/work --rm ${DOCKER_NM} start.sh \
	conda env export -n ${ENV_NM} | sed '1d;$d' | sed '$d' \
	| perl -p -e 's/^([^=]+=)([^=]+)=.+$/$1$2/m' \
	| grep -Ev '\- _|cpp|backports|\- lib|\- tk|\- xorg' \
	| perl -p -e 's|sompy==[\.0-9]+|git+http://github.com/kingsgeocomp/SOMPY#egg=sompy|' > conda/environment_py.yml
