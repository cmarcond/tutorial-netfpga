#!/usr/bin/perl

use strict;

my $bin_dir = "$ENV{'NF2_ROOT'}/bitfiles/reference_router.bit";

if ($ARGV[0] eq "--use_bin")
{
  $bin_dir = $ARGV[1];
}

system("make -C ../../../");
#`nf2_download $bin_dir`;
system("pushd $ENV{'NF2_ROOT'}/projects/scone/sw/ ; ./scone &");
`popd`;
system("pushd $ENV{'NF2_ROOT'}/lib/java/gui ; ./router.sh");
`popd`;
`killall scone`;

exit 0;

