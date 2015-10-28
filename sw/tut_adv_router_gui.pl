#!/usr/bin/perl

use strict;

my $bin_dir = "$ENV{'NF2_ROOT'}/bitfiles/router_buffer_sizing.bit";

if ($ARGV[0] eq "--use_bin")
{
  $bin_dir = $ARGV[1];
}

system("make -C ../../../");
`nf2_download $bin_dir`;
system("pushd $ENV{'NF2_ROOT'}/projects/scone/sw/ ; ./scone &");
`popd`;
system("pushd $ENV{'NF2_ROOT'}/lib/java/gui ; ./eventcap.sh");
`popd`;
`killall scone`;

exit 0;
