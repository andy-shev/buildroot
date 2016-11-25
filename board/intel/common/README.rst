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

_`BOARD_INTEL_ACPI_TABLES`

BOARD_INTEL_ACPI_TABLES
	list of table names to built into the ``initrd``.

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

Adding custom ACPI SSDT tables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can add additional ACPI tables to the ``initrd`` (think of device tree
overlays) if you need to have some special devices for example. The ASL files
should be stored in board specific directories as they vary from one board to
another. Below we add SPI test device for Intel `Joule`_ board::

	% make KERNEL_SRC=~/linux BR2_TARGET_GENERIC_GETTY_PORT=ttyS2	\
				  BOARD_INTEL_DIR=board/intel/joule	\
				  BOARD_INTEL_ACPI_TABLES=spidev.asl

The resulting image is called ``output/images/joule-acpi-rootfs.cpio``.
If the disk image creation is asked it will contain the tables as well.

Note, that the `BOARD_INTEL_ACPI_TABLES`_ is optional and in the resulting
image you will always get all ASL excerpts compiled and copied to
``acpi-tables`` folder in the root of file system. They can be loaded via
ConfigFS mechanism at run-time.

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
