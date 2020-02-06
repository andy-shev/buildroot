#!/bin/sh -e
# SPDX-License-Identifier: GPL-2.0

PATH=/bin:/sbin:/usr/bin:/usr/sbin
netbootconf=/tmp/netboot.cfg
bootdir=/tmp/boot
noinitrd="noinitrd"

# colour_print($fmt,...)
colour_print() {
	local fmt="$1"; shift;
	printf "[\033[1;33mNETBOOT\033[m]: $fmt" "$@"
}

# tftp_download($local,$remote)
tftp_download() {
	colour_print "fetching %s: " "$(basename $1)"
	tftp -g -b 1418 -l "$1" -r "$2" "$serverid" && echo "done."
}

case "$1" in
bound)
	colour_print "bound: %s\n" "$interface"

	[ -n "$broadcast" ] && BROADCAST="broadcast $broadcast"
	[ -n "$subnet" ] && NETMASK="netmask $subnet"
	ifconfig "$interface" "$ip" $BROADCAST $NETMASK

	[ -z "$bootfile" ] && bootfile="$boot_file"

	tftp_download "$netbootconf" "$bootfile"

	source "$netbootconf"

	colour_print "kernel: %s\n" "$kernel"
	colour_print "initrd: %s\n" "$initrd"
	colour_print "cmdline: %s\n" "$cmdline"

	mkdir $bootdir

	tftp_download $bootdir/vmlinuz "$kernel"
	tftp_download $bootdir/cmdline "$cmdline"
	if grep -qw "$noinitrd" $bootdir/cmdline; then
		colour_print "'%s' in kernel command line, not loading initrd\n" "$noinitrd"
	else
		tftp_download $bootdir/initrd "$initrd"
		do_initrd="--initrd $bootdir/initrd"
	fi

	cmdline="$(cat $bootdir/cmdline)"
	if [ -e /sys/firmware/efi/systab ]; then
		systab="$(sort -r /sys/firmware/efi/systab | \
			  sed -n -e 's/ACPI20/acpi_rsdp/p; s/SMBIOS3\?/dmi_entry_point/p;' | \
			  tr '\n' ' ')"
		cmdline="$cmdline $systab"
	fi
	if [ -e /sys/class/net/$interface/address ]; then
		cmdline="$cmdline mac=$(cat /sys/class/net/$interface/address)"
	fi

	colour_print "passing command-line: %s\n" "$cmdline"
	colour_print "kexec'ing the kernel\n"
	kexec -l $bootdir/vmlinuz $do_initrd --command-line="$cmdline"
	kexec -e
	;;
esac
