#!/usr/bin/perl -w
use strict;
use base "installstep";
use bmwqemu;

sub is_applicable()
{
	my $self=shift;
	return $self->SUPER::is_applicable && !$ENV{LIVECD};
}

sub ocrconflict()
{
	my $data=getcurrentscreenshot();
	my $ocr=ocr::get_ocr(\$data, "-l 200", [250,100,700,600]);
	return 1 if($ocr=~m/can.*solve/i);
	return 1 if($ocr=~m/dependencies automatically/i);
	return 0;
}

sub run()
{
	my $self=shift;
	if($ENV{DOCRUN} || waitimage("software-conflict-*",9) || ocrconflict) {
		sendkey $cmd{change};	# Change
		sendkey $cmd{software};	# Software
		waitidle;
		for(1..3) {
			sendkey "down";
		}
		sleep 4;
		$self->take_screenshot;
		sendkey $cmd{accept}; # Accept
		sleep 2;
		sendkey "alt-o"; # cOntinue
		waitidle;
	}
}

1;
