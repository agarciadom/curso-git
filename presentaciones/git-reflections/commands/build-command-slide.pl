#!/usr/bin/perl -w
use strict;

# reads in git help -a
# reads in $1 or template.svg
# builds $2 or out.svg

my $src = "template.svg";
my $dst = "out.svg";
my $lst;

# ------------------------------------------------------------------------

sub parse_cmdline {
        for (my $i=0; $i <= $#ARGV; ) {
                my $arg = $ARGV[$i++];
                if ( $arg eq '-h' ) {
                        print <<END
$0 [options]

 -i <input>                  template file ($src)
 -o <output>                 generate file ($dst)
 -u <colour> <list-file>     (optional) highlight file
END
;
                        exit(0);

                } elsif ( $arg eq '-i' ) {
                        $src = $ARGV[$i++];

                } elsif ( $arg eq '-o' ) {
                        $dst = $ARGV[$i++];

                } elsif ( $arg eq '-u' ) {
                        my $co = $ARGV[$i++] or die "need a color paramater for -u\n";
                        my $fn = $ARGV[$i++] or die "need a file paramater for -u\n";
                        parse_markup($co, $fn);

                } else {
                        die "didn't know how to parse option '$arg'\n";
                }
        }
}

# ------------------------------------------------------------------------
my %markup = ();
sub parse_markup {
        my ($co, $file) = @_;

        open(FILE, '<', $file) or die "couldn't read from $file\n";

        while(<FILE>) {
                s/^\s*//;
                s/\s*$//;
                $markup{$_} = $co;
        }

        close(FILE);
}

# ------------------------------------------------------------------------
my @cmds = ( `COLUMNS=1 git help -a | sed -n -e '/^available/,/^\$/{/^ /p}'` );

sub next_command {
        my $cmd = shift @cmds || "";
        $cmd =~ s/^\s*//;
        $cmd =~ s/\s*$//;
        return $cmd;
}

# ------------------------------------------------------------------------
sub munge {
        my (@block) = @_;

        #print "# ------------in\n";
        #print @block;

        my $fill_col;

        foreach (@block) {
                next if not m/XXX/;
                my $cmd = next_command;
                $fill_col = $markup{$cmd};
                s/XXX/$cmd/;
        }

        if (defined $fill_col) {
                foreach (@block) {
                        s/fill:#000000/fill:#$fill_col/;
                }
        }

        #print "# ------------out\n";
        #print @block;

        return @block;
}

# ------------------------------------------------------------------------

my @block = ();

sub block_reset {
        my ($start) = @_;
        @block = $start && ( $start ) || ( );
}

sub block_append {
        push @block, @_;
}

sub block_dump {
        print DST munge(@block);
        block_reset;
}

# ------------------------------------------------------------------------

parse_cmdline

open(SRC, '<', $src) || die "couldn't read from $src\n";
open(DST, '>', $dst) || die "couldn't write to $dst\n";
while (<SRC>) {
        if ( m{^(.*)(\<text.*)} ) {
                block_append($1);
                block_dump;
                block_reset ("$2\n");

        } elsif ( m{\</text\>} ) {

                block_append($_);
                block_dump;
                block_reset;

        } else {
                block_append($_);

        }
}

block_dump;

close (SRC);
close (DST);
