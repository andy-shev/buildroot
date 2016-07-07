===========
 Intel IoT
===========

----------------------------------------
 Common infrastructure for Intel boards
----------------------------------------

:Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
:Date: 2016-08-17

Quick instructions
------------------

Building an image
~~~~~~~~~~~~~~~~~

For building a normal bootable image, you need to do following steps:

1) Build your own kernel.

2) Configure Buildroot.

The Buildroot configuration would be done by running::

	% make <BOARD>_defconfig

For most of the boards it's good enough to use generic [intel_defconfig]_.

3) Build Buildroot.

Build the necessary Buildroot packages and resulting image::

	% make KERNEL_SRC=~/linux

where ``~/linux`` is whatever the path to the kernel output folder is.

4) Get the resulting image.

The resulting image is placed under output/images and is called either
``rootfs.cpio.bz2`` or ``initrd``. ``initrd`` is the link to the last modified
image since some scripts may alter it on post image stage.

Supported environment variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The scripts under ``board/intel/common`` accept several environment variables
that can be used to alter the default behaviour. Typically you do something
like::

	% make KERNEL_SRC=~/linux

in order to take advantage of these.

BOARD_INTEL_CUSTOM_CMDLINE
	provides a custom appendix to the command line.

BOARD_INTEL_DIR
	points to a specific board directory.

KERNEL_SRC
	path to your kernel output folder.

Alter console
~~~~~~~~~~~~~

By default ``ttyS0`` is used as a default console for both kernel and
user space. The **BR2_TARGET_GENERIC_GETTY_PORT** variable could be used
to alter this setting.

Supported boards
~~~~~~~~~~~~~~~~

.. [intel_defconfig] Generic configuration file for most of Intel SoCs.

Examples
~~~~~~~~

- _`T100TA` ASUS T100TA (Baytrail) and the rest with ``ttyUSB0``::

	% make KERNEL_SRC=~/linux BR2_TARGET_GENERIC_GETTY_PORT=ttyUSB0 \
				  BOARD_INTEL_CUSTOM_CMDLINE="reboot=h,p"

- _`Galileo` Intel Galileo (Quark)::

	% make KERNEL_SRC=~/linux BR2_TARGET_GENERIC_GETTY_PORT=ttyS1

- _`Joule` Intel Joule (Broxton) and Intel Edison (Merrifield)::

	% make KERNEL_SRC=~/linux BR2_TARGET_GENERIC_GETTY_PORT=ttyS2

- _`Minnowboard` Minnowboard [#]_::

	% make KERNEL_SRC=~/linux BR2_TARGET_GENERIC_GETTY_PORT=ttyPCH0

.. [#] Minnowboard MAX or Turbot goes the standard way with ``ttyS0``.
