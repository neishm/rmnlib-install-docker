VGRID_RELEASE=6.4

ifeq ($(shell uname -m | cut -c1-3),arm)
default: jessie
jessie: EXTRA_TAGS=--tag rmnlib-install
all: jessie
else
default: 18.04
18.04: EXTRA_TAGS=--tag rmnlib-install
all: 14.04 16.04 18.04
endif


# Need an older vgrid for Ubuntu 14.04, or gfortran can't compile it.
14.04: VGRID_RELEASE=6.1.gnu

%.04: Dockerfile.template
	echo "# Auto-generated from $< - do not edit!\n" > Dockerfile
	sed 's/$$DISTRO/ubuntu:$@/;s/$$VGRID_RELEASE/$(VGRID_RELEASE)/' $< >> Dockerfile
	sudo docker build --force-rm --tag rmnlib-install-$@ $(EXTRA_TAGS) .
	@echo rmnlib-install-$@ is now ready to use.

jessie: Dockerfile.template
	echo "# Auto-generated from $< - do not edit!\n" > Dockerfile
	sed 's!$$DISTRO!balenalib/rpi-raspbian:jessie!;s/$$VGRID_RELEASE/$(VGRID_RELEASE)/' $< >> Dockerfile
	sudo docker build --force-rm --tag rmnlib-install-$@ $(EXTRA_TAGS) .
	@echo rmnlib-install-$@ is now ready to use.
