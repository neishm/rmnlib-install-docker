VGRID_RELEASE=6.4

default: 18.04
18.04: EXTRA_TAGS=--tag rmnlib-install

all: 14.04 16.04 18.04

# Need an older vgrid for 14.04, or gfortran can't compile it.
14.04: VGRID_RELEASE=6.1.gnu

%.04: Dockerfile.template
	echo "# Auto-generated from $< - do not edit!\n" > Dockerfile
	sed 's/$$DISTRO/ubuntu:$@/;s/$$UID/'`id -u`'/;s/$$GID/'`id -g`'/;s/$$VGRID_RELEASE/$(VGRID_RELEASE)/' $< >> Dockerfile
	sudo docker build --tag rmnlib-install-$@ $(EXTRA_TAGS) .
	@echo rmnlib-install-$@ is now ready to use.
