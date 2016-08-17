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

5) Find disk image if asked for.

When `BOARD_INTEL_DISK_IMAGE`_ is specified the resulting image will be called
either ``<BOARD>.img`` or ``diskimage.img``, which is link to the previous.

Supported environment variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The scripts under ``board/intel/common`` accept several environment variables
that can be used to alter the default behaviour. Typically you do something
like::

	% make KERNEL_SRC=~/linux BOARD_INTEL_NETBOOT=y

in order to take advantage of these.

_`BOARD_INTEL_ACPI_TABLES`

BOARD_INTEL_ACPI_TABLES
	list of table names to built into the ``initrd``.

BOARD_INTEL_CUSTOM_CMDLINE
	provides a custom appendix to the command line.

BOARD_INTEL_DIR
	points to a specific board directory.

_`BOARD_INTEL_DISK_IMAGE`

BOARD_INTEL_DISK_IMAGE
	if set, the disk image will be created.

BOARD_INTEL_EFIBIN
	path to a folder that contains a custom EFI binary, i.e.
	``bootia32.efi`` or ``bootx64.efi``, that is started at boot time.

BOARD_INTEL_NETBOOT
	if set, netbooting is enabled.

BOARD_MAC_ADDRESS
	provides custom MAC address if netbooting is enabled.

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

Flash netboot image
-------------------

Some boards require to flash the netboot image to eMMC or another special care.
There are instruction how to do it.

Intel Edison
~~~~~~~~~~~~

You have to flash the stock image first. After you get it flashed, boot it in
the OS and connect to the host machine in the USB Mass Storage mode. Upload the
boot stick image as usual.

When previous is done reboot to U-boot menu and add the following environment
variables::

	boot_netboot=zboot 0x100000 0 0x6000000 0x1800000
	bootargs_netboot=console=tty1 console=ttyS2,115200n8 rootfstype=ramfs rw netboot quiet
	bootcmd_netboot=setenv bootargs ${bootargs_netboot}; run load_netboot; run boot_netboot
	load_netboot=load mmc 0:9 0x100000 vmlinuz.efi; load mmc 0:9 0x1800000 initrd

Then, run the commands::

	setenv bootcmd_orig ${bootcmd}
	setenv bootcmd ${bootcmd_netboot}
	saveenv

When the above is done, either reboot the device or run via ``boot`` command.
