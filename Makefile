export DOCKER_NM='jreades/sds:0.7.1'
export ENV_NM='sds2020'
test: test_py # test_rs
test_py:
	docker run -v `pwd`:/home/jovyan/work ${DOCKER_NM} start.sh jupyter nbconvert --execute /home/jovyan/test/gds_py/check_py_stack.ipynb
test_r:
	docker run -v `pwd`:/home/jovyan/work ${DOCKER_NM} start.sh jupyter nbconvert --execute /home/jovyan/test/gds/check_r_stack.ipynb
write_stacks: yml
	# Python
	docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh conda list -n ${ENV_NM} > conda/environment_py.txt
	docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh sed -i "1 i SDS version: ${DOCKER_NM}" conda/environment_py.txt
	docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh python -c "import subprocess, pandas; fo=open('conda/environment_py.md', 'w'); fo.write(pandas.read_json(subprocess.check_output(['conda', 'list', '-n', '${ENV_NM}', '--json']))[['name', 'version', 'build_string', 'channel']].to_markdown());fo.close()"
	docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh sed -i "1s/^/\n/" conda/environment_py.md
	# R
	#docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh Rscript -e "ip <- as.data.frame(installed.packages()[,c(1,3:4)]); print(ip)" > gds/stack_r.txt
	#docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh sed -i '1iSDS version: ${DOCKER_NM}' gds/stack_r.txt
	#docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh Rscript -e "library(knitr); ip <- as.data.frame(installed.packages()[,c(1,3:4)]); fc <- file('gds/stack_r.md'); writeLines(kable(ip, format = 'markdown'), fc); close(fc);"
	#docker run -v ${PWD}:/home/jovyan --rm ${DOCKER_NM} start.sh sed -i "1s/^/\n/" gds/stack_r.md
yml:
	docker run -v ${PWD}:/home/jovyan/work --rm ${DOCKER_NM} start.sh \
	conda env export -n ${ENV_NM} --from-history | sed '1d;$d' | sed '$d' > conda/environment_py.yml
	docker run -v ${PWD}:/home/jovyan/work --rm ${DOCKER_NM} start.sh \
        conda env export -n ${ENV_NM} | sed '1d;$d' | sed '$d' \
	| perl -p -e 's/^([^=]+=)([^=]+)=.+$/$1$2/m' \ 
	| grep -Ev "\- _|cpp|backports|\- lib|\- tk|\- xorg" \
	| perl -p -e 's|sompy==[\.0-9]+|git+http://github.com/kingsgeocomp/SOMPY#egg=sompy|' \
	> conda/environment_py_full.yml
website_build:
	cd website && \
	rm -rf _includes && \
	rm -rf _site
	mkdir -p website/_includes
	#--- Populate content ---#
	cp README.md website/_includes
	cp CONTRIBUTING.md website/_includes
	cp docker/install_guide.md website/_includes/docker_install_guide.md
	cp docker/build_guide.md website/_includes/docker_build_guide.md
	cp virtualbox/virtualbox_user_setup.md website/_includes
	cp virtualbox/README_docker-machine.md website/_includes
	cp virtualbox/README_vagrant.md website/_includes
	cp gds_py/stack_py.md website/_includes/stack_py.md
	cp gds/stack_r.md website/_includes/stack_r.md
	cp gds_py/README.md website/_includes/gds_py_README.md
	cp gds/README.md website/_includes/gds_README.md
	cp gds_dev/README.md website/_includes/gds_dev_README.md
	#---
website: website_build
	cd website && jekyll build
	rm -rf docs
	mv website/_site docs
	cd website && rm -rf _includes
	touch docs/.nojekyll
website_local: website_build
	# https://tonyho.net/jekyll-docker-windows-and-0-0-0-0/
	export JEKYLL_ENV=docker && \
	cd website && \
	jekyll serve --host 0.0.0.0 \
				 --incremental \
				 --config  _config.yml,_config.docker.yml && \
	rm -rf _includes
	export JEKYLL_ENV=development
