#!/usr/bin/perl -w
#
#
my $out_cnt = 0;
my $in_cnt = 0;
my $old_lib = 'fred';
my $first_line = 'Y';
open (INFILE, "$ARGV[0]") or die ("Cannot open file list\n");
#
while ($inrec = <INFILE>) {
   $in_cnt++;
   chomp $inrec;
   if ( $first_line eq 'Y') {
      $inrec =~ s/,Institution Code//;
      $header = $inrec;
      $first_line = 'N';
   } else {
      $inrec =~ /01CARLI_(...)/;
      $lib = $1;          
      $inrec =~ s/,01CARLI.*//;
      if ( $old_lib ne $lib ) {
         if ( $old_lib ne 'fred' ) {
            close OUT;
         }
         print "$old_lib count: $out_cnt\n";
         $out_cnt = 0;
         open (OUT, ">$ARGV[1]_$lib.csv") or die ("Cannot open output file.\n");
         $old_lib = $lib;
         print OUT "$header\n";
      }
      print OUT "$inrec\n";
      $out_cnt++;
   }
}
close INFILE;
close OUT;
print "$old_lib count: $out_cnt\n";

print "records in:   $in_cnt\n";
