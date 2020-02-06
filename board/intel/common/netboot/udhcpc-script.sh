#!/bin/sh -e
# SPDX-License-Identifier: GPL-2.0

PATH=/bin:/sbin:/usr/bin:/usr/sbin
netbootconf=/tmp/netboot.cfg
bootdir=/tmp/boot

# tftp_download($local,$remote)
tftp_download() {
	printf "[\033[1;33mNETBOOT\033[m]: fetching $(basename $1): "
	tftp -g -b 1418 -l "$1" -r "$2" "$serverid" && echo "done."
}

case "$1" in
bound)
	printf "[\033[1;33mNETBOOT\033[m]: bound: $interface\n"

	[ -n "$broadcast" ] && BROADCAST="broadcast $broadcast"
	[ -n "$subnet" ] && NETMASK="netmask $subnet"
	ifconfig "$interface" "$ip" $BROADCAST $NETMASK

	[ -z "$bootfile" ] && bootfile="$boot_file"

	tftp_download "$netbootconf" "$bootfile"

	source "$netbootconf"

	printf "[\033[1;33mNETBOOT\033[m]: kernel: $kernel\n"
	printf "[\033[1;33mNETBOOT\033[m]: initrd: $initrd\n"
	printf "[\033[1;33mNETBOOT\033[m]: cmdline: $cmdline\n"

	mkdir $bootdir

	tftp_download $bootdir/vmlinuz "$kernel"
	tftp_download $bootdir/cmdline "$cmdline"
	if grep -qw noinitrd $bootdir/cmdline; then
		printf "[\033[1;33mNETBOOT\033[m]: 'noinitrd' in kernel command line, not loading initrd\n"
	else
		tftp_download $bootdir/initrd "$initrd"
		do_initrd="--initrd $bootdir/initrd"
	fi

	cmdline="$(cat $bootdir/cmdline)"
	if [ -e /sys/firmware/efi/systab ]; then
		cmdline="$cmdline $(sort -r /sys/firmware/efi/systab | \
			sed -n -e 's/ACPI20/acpi_rsdp/p; s/SMBIOS3\?/dmi_entry_point/p;')"
	fi
	if [ -e /sys/class/net/$interface/address ]; then
		cmdline="$cmdline mac=$(cat /sys/class/net/$interface/address)"
	fi

	printf "[\033[1;33mNETBOOT\033[m]: passing command-line: $cmdline\n"
	printf "[\033[1;33mNETBOOT\033[m]: kexec'ing the kernel\n"
	kexec -l $bootdir/vmlinuz $do_initrd --command-line="$cmdline"
	kexec -e
	;;
esac
