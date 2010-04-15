#! /usr/bin/perl

while(<STDIN>)
{
  my($line) = $_;
		if ($line =~ m/^(.+?) \((.+?)\)(.+?)$/g)
		{
			print "$1$3\n";
			print "$2$3\n";
		}
		print $line;
}


