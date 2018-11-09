#!/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Chart::Gnuplot;
use HTML::Table;
use List::Util qw( max );
use Math::Round;
#
# ARGS MANAGEMENT
#
my ($argoption) = @ARGV;

#
# DATA
#
#Quantidade de outputs ignorados
my $IGNORAR = 10;

my %info_tools = ();
my %info_profiles = ();
my %info_ids = ();
my @tool_profiles = (); 
my @folders_progs = `ls -l ../Outputs/ | grep '^d' | awk '{print \$9}'`;

for my $prog (@folders_progs) {

	chomp $prog;
	@tool_profiles = `ls -l -tr ../Outputs/$prog/ | grep '^d' | awk '{print \$9}'`;
	for my $tool_profile (@tool_profiles) {

		chomp $tool_profile;
		my ($tool, $profile) = split(',', $tool_profile);

		my @time_values = ();
		my @cpu_values = ();
		my @memory_values = ();
		my @files = `ls ../Outputs/$prog/$tool_profile`;	

		for my $file (@files) {
			chomp $file;
			open(my $fh, "<", "../Outputs/$prog/$tool_profile/$file") or die "Could not open file '$file' $!";

			my $i = 0;
			while (my $row = <$fh>) {
				chomp $row;

				if($row =~ /Total time:/) {
					$_ = $row;
					s/.+?([0-9\.]+)s.*/$1/;
					$info_tools{$prog}{$tool}{$profile}{$file}{time} = $_;
					$info_profiles{$prog}{$profile}{$tool}{$file}{time} = $_;
					next;
				}

				if($row =~ /J consumed/) {
					$_ = $row;
					s/.+?([0-9\.]+)J.*/$1/;
					$info_tools{$prog}{$tool}{$profile}{$file}{$i} = $_;
					$info_profiles{$prog}{$profile}{$tool}{$file}{$i} = $_;
					$i++;
				}
			}
			close($fh);

			push @time_values, $info_tools{$prog}{$tool}{$profile}{$file}{time};
			push @cpu_values, $info_tools{$prog}{$tool}{$profile}{$file}{1};
			push @memory_values, $info_tools{$prog}{$tool}{$profile}{$file}{3};

			push @time_values, $info_profiles{$prog}{$profile}{$tool}{$file}{time};
			push @cpu_values, $info_profiles{$prog}{$profile}{$tool}{$file}{1};
			push @memory_values, $info_profiles{$prog}{$profile}{$tool}{$file}{3};
		}

		@time_values = sort @time_values;
		splice @time_values, 0, $IGNORAR;
		splice @time_values, -$IGNORAR, $IGNORAR;
		my $time_mean = sprintf("%.3f",(eval join '+', @time_values) / (scalar(@time_values)));
		$info_tools{$prog}{$tool}{$profile}{time_mean} = $time_mean;
		$info_profiles{$prog}{$profile}{$tool}{time_mean} = $time_mean;
		$info_ids{$prog}{$profile}{time_mean} = $time_mean;

		@cpu_values = sort @cpu_values;
		splice @cpu_values, 0, $IGNORAR;
		splice @cpu_values, -$IGNORAR, $IGNORAR;
		my $cpu_mean = sprintf("%.3f",(eval join '+', @cpu_values) / (scalar(@cpu_values))); 
		$info_tools{$prog}{$tool}{$profile}{cpu_mean} = $cpu_mean;
		$info_profiles{$prog}{$profile}{$tool}{cpu_mean} = $cpu_mean;
		$info_ids{$prog}{$profile}{cpu_mean} = $cpu_mean;

		@memory_values = sort @memory_values;
		splice @memory_values, 0, $IGNORAR;
		splice @memory_values, -$IGNORAR, $IGNORAR;
		my $memory_mean = sprintf("%.3f",(eval join '+', @memory_values) / (scalar(@memory_values)));
		$info_tools{$prog}{$tool}{$profile}{memory_mean} = $memory_mean;
		$info_profiles{$prog}{$profile}{$tool}{memory_mean} = $memory_mean;
		$info_ids{$prog}{$profile}{memory_mean} = $memory_mean;

	}
}

#print Dumper (%info_tools);
#print Dumper (%info_profiles);
#print Dumper (%info_ids);

#
# GRÁFICO E TABELA
#
mkdir "Charts" unless(-d "Charts");
if ($argoption eq "-chartstools") {
	mkdir "Charts/Tools" unless(-d "Charts/Tools");	
	for my $prog (@folders_progs) {
		chomp $prog;
		mkdir "Charts/Tools/$prog" unless(-d "Charts/Tools/$prog");	

		for my $tool_profile (@tool_profiles) {
			chomp $tool_profile;
			my ($tool, $profile) = split(',', $tool_profile);

			my @profiles = ();
			my @time_values = ();
			my @cpu_values = ();
			my @memory_values = ();

			for my $profile (sort keys %{$info_tools{$prog}{$tool}}) {
				push @time_values, $info_tools{$prog}{$tool}{$profile}{time_mean};
				push @cpu_values, $info_tools{$prog}{$tool}{$profile}{cpu_mean};
				push @memory_values, $info_tools{$prog}{$tool}{$profile}{memory_mean};
				push @profiles, $profile;
			}
			
			my $max_energy = max(@cpu_values) + max(@memory_values);
			my $max_time = max(@time_values);

			#
			# TABELA
			#
			my $table = new HTML::Table(
				-class=>'table table-bordered table table-hover',
				-style=>'text-align:center; max-width: 600px; margin-left:auto; margin-right:auto;',
			);

			$table -> addRow("Profiles", @profiles);
			$table -> setRowClass(1, 'active');
			$table -> addRow("Time (s)", @time_values);
			$table -> addRow("CPU (J)", @cpu_values);
			$table -> addRow("Memory (J)", @memory_values);

			#
			# GRAFICO
			#
			my $chart = Chart::Gnuplot->new(
			    output  => "Charts/Tools/$prog/$prog-$tool.png",
			    title   => 'Consumption Values',
			    xlabel  => "Profiles",
			    ylabel  => 'Energy (J)',
			    y2label => 'Time (s)',
			    bg      => { 
					 color   => "#c9c9ff", 
					 density => 0.3 
			   	},
			   	grid    => "on",
			   	bmargin => 6,
			    legend  => {
		        position => "outside center bottom",
		        order    => "horizontal reverse",
		        width  => 2,
		        height => 0.5,
		        border   => 'on',
		    	},
			    yrange  => [0, $max_energy+$max_energy*0.10],
			    y2range => [0, $max_time+$max_time*0.10],
			    xtics   => { mirror => 'off' },
			    ytics   => { mirror => 'off' },
			    y2tics  => 'on',
			    "style histogram" => "rowstacked",
			);

			my $memory_bar = Chart::Gnuplot::DataSet->new(
			    xdata => \@profiles,
			    ydata => \@memory_values,
			    title => "MEMORY",
			    color => "#525bc3",
			    fill  => {density => 0.3},
			    style => "histograms",
			);

			my $cpu_bar = Chart::Gnuplot::DataSet->new(
			    xdata => \@profiles,
			    ydata => \@cpu_values,
			    title => "CPU",
			    color => "#ff0000",	    
			    fill  => {density => 0.3},
			    style => "histograms",
			);
			
			my $time_line = Chart::Gnuplot::DataSet->new(
			    xdata  => \@time_values,
				ydata  => \@profiles,
			 	style  => 'lines',
			  	color => "#000000",
			  	title  => "TIME",
			  	axes   => 'x1y2',
			);

			$chart->plot2d($cpu_bar, $memory_bar, $time_line);

			#HTML			
			my $header = 
			"<!DOCTYPE html>
			<html>
				<head>
					<link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css' rel='stylesheet'>
					<script src='https://code.jquery.com/jquery-2.1.3.min.js'></script>
					<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js'></script>
					<title>$prog - $tool</title>
				</head>";
			my $body =
			"<body>
				<div class='container' style = 'margin-top: 20px'>
				<h2 style ='text-align: center'>$prog - $tool</h2>";
			my $img = "</div>
			<div >
				<img src=\"$prog-$tool.png\" style='display: block; margin-left: auto; margin-right: auto;'>
			</div>";
			my $footer = "</body><html>";

			my $html_file = "Charts/Tools/$prog/$prog-$tool.html";
			open(my $fh, '>', $html_file) or die "Could not open file '$html_file' $!";
			print $fh $header, $body, $table->getTable, $img, $footer;
			close $fh;
		}
	}
}

elsif ($argoption eq "-chartsprofiles") {
	mkdir "Charts/Profiles" unless(-d "Charts/Profiles");	
	for my $prog (@folders_progs) {

		chomp $prog;
		mkdir "Charts/Profiles/$prog" unless(-d "Charts/Profiles/$prog");	

		for my $tool_profile (@tool_profiles) {
			chomp $tool_profile;
			my ($tool, $profile) = split(',', $tool_profile);

			my @tools = ();
			my @time_values = ();
			my @cpu_values = ();
			my @memory_values = ();

			for my $tool (sort keys %{$info_profiles{$prog}{$profile}}) {
				push @time_values, $info_profiles{$prog}{$profile}{$tool}{time_mean};
				push @cpu_values, $info_profiles{$prog}{$profile}{$tool}{cpu_mean};
				push @memory_values, $info_profiles{$prog}{$profile}{$tool}{memory_mean};
				push @tools, $tool;
			}
			
			my $max_energy = max(@cpu_values) + max(@memory_values);
			my $max_time = max(@time_values);

			#
			# TABELA
			#
			my $table = new HTML::Table(
				-class=>'table table-bordered table table-hover',
				-style=>'text-align:center; max-width: 600px; margin-left:auto; margin-right:auto;',
			);

			$table -> addRow("Tool", @tools);
			$table -> setRowClass(1, 'active');
			$table -> addRow("Time (s)", @time_values);
			$table -> addRow("CPU (J)", @cpu_values);
			$table -> addRow("Memory (J)", @memory_values);

			#
			# GRAFICO
			#
			my $chart = Chart::Gnuplot->new(
			    output  => "Charts/Profiles/$prog/$prog-$profile.png",
			    title   => 'Consumption Values',
			    xlabel  => "Tool",
			    ylabel  => 'Energy (J)',
			    y2label => 'Time (s)',
			    bg      => { 
					 color   => "#c9c9ff", 
					 density => 0.3 
			   	},
			   	grid    => "on",
			   	bmargin => 6,
			    legend  => {
		        position => "outside center bottom",
		        order    => "horizontal reverse",
		        width  => 2,
		        height => 0.5,
		        border   => 'on',
		    	},
			    yrange  => [0, $max_energy+$max_energy*0.10],
			    y2range => [0, $max_time+$max_time*0.10],
			    xtics   => { mirror => 'off' },
			    ytics   => { mirror => 'off' },
			    y2tics  => 'on',
			    "style histogram" => "rowstacked",
			);

			my $memory_bar = Chart::Gnuplot::DataSet->new(
			    xdata => \@tools,
			    ydata => \@memory_values,
			    title => "MEMORY",
			    color => "#525bc3",
			    fill  => {density => 0.3},
			    style => "histograms",
			);

			my $cpu_bar = Chart::Gnuplot::DataSet->new(
			    xdata => \@tools,
			    ydata => \@cpu_values,
			    title => "CPU",
			    color => "#ff0000",	    
			    fill  => {density => 0.3},
			    style => "histograms",
			);

			my $time_line = Chart::Gnuplot::DataSet->new(
				xdata  => \@time_values,
				ydata  => \@tools,
				style  => 'lines',
				color => "#000000",
				title  => "TIME",
				axes   => 'x1y2',
			);

			$chart->plot2d($cpu_bar, $memory_bar, $time_line);

			#HTML		
			my $header = 
			"<!DOCTYPE html>
			<html>
				<head>
					<link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css' rel='stylesheet'>
					<script src='https://code.jquery.com/jquery-2.1.3.min.js'></script>
					<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js'></script>
					<title>$prog - $profile</title>
				</head>";
			my $body =
			"<body>
				<div class='container' style = 'margin-top: 20px'>
				<h2 style ='text-align: center'>$prog - $profile</h2>";
			my $img = "</div>
			<div >
				<img src=\"$prog-$profile.png\" style='display: block; margin-left: auto; margin-right: auto;'>
			</div>";
			my $footer = "</body><html>";

			my $html_file = "Charts/Profiles/$prog/$prog-$profile.html";
			open(my $fh, '>', $html_file) or die "Could not open file '$html_file' $!";
			print $fh $header, $body, $table->getTable, $img, $footer;
			close $fh;
		}
	}
}

elsif ($argoption eq "-chartstotalids") {
	mkdir "Charts/TotalIDs" unless(-d "Charts/TotalIDs");	
	for my $prog (@folders_progs) {

		chomp $prog;
		my @profiles = ();
		my @time_values = ();
		my @cpu_values = ();
		my @memory_values = ();

		for my $profile (sort { $a <=> $b } keys %{$info_ids{$prog}}) {
			push @time_values, $info_ids{$prog}{$profile}{time_mean};
			push @cpu_values, $info_ids{$prog}{$profile}{cpu_mean};
			push @memory_values, $info_ids{$prog}{$profile}{memory_mean};
			push @profiles, $profile;
		}
		
		my $max_energy = max(@cpu_values) + max(@memory_values);
		my $max_time = max(@time_values);

		#
		# TABELA
		#
		my $table = new HTML::Table(
			-class=>'table table-bordered table table-hover',
			-style=>'text-align:center; max-width: 600px; margin-left:auto; margin-right:auto;',
		);

		$table -> addRow("Profiles", @profiles);
		$table -> setRowClass(1, 'active');
		$table -> addRow("Time (s)", @time_values);
		$table -> addRow("CPU (J)", @cpu_values);
		$table -> addRow("Memory (J)", @memory_values);

		#
		# GRAFICO
		#
		my $chart = Chart::Gnuplot->new(
		    output  => "Charts/TotalIDs/$prog.png",
		    title   => 'Consumption Values',
		    xlabel  => "Profiles",
		    ylabel  => 'Energy (J)',
		    y2label => 'Time (s)',
		    bg      => { 
				 color   => "#c9c9ff", 
				 density => 0.3 
		   	},
		   	grid    => "on",
		   	bmargin => 6,
		    legend  => {
		        position => "outside center bottom",
		        order    => "horizontal reverse",
		        width  => 2,
		        height => 0.5,
		        border   => 'on',
	    	},
		    yrange  => [0, $max_energy+$max_energy*0.10],
		    y2range => [0, $max_time+$max_time*0.10],
		    xtics   => { mirror => 'off' },
		    ytics   => { mirror => 'off' },
		    y2tics  => 'on',
		    "style histogram" => "rowstacked",
		);

		my $memory_bar = Chart::Gnuplot::DataSet->new(
		    xdata => \@profiles,
		    ydata => \@memory_values,
		    title => "MEMORY",
		    color => "#525bc3",
		    fill  => {density => 0.3},
		    style => "histograms",
		);

		my $cpu_bar = Chart::Gnuplot::DataSet->new(
		    xdata => \@profiles,
		    ydata => \@cpu_values,
		    title => "CPU",
		    color => "#ff0000",	    
		    fill  => {density => 0.3},
		    style => "histograms",
		);

		#necessary to print the line from the positions 0-25 and not 1-26 (ids numbers)
		my $size = (scalar @profiles);
		my @profilesaux = (0..$size-1);

		my $time_line = Chart::Gnuplot::DataSet->new(
			xdata  => \@profilesaux,
		    ydata  => \@time_values,
		  	color => "#000000",
		  	title  => "TIME",
		 	style  => 'lines',
		  	axes   => 'x1y2',
		);

		$chart->plot2d($cpu_bar, $memory_bar, $time_line);

		#HTML	
		my $header = 
		"<!DOCTYPE html>
		<html>
			<head>
				<link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css' rel='stylesheet'>
				<script src='https://code.jquery.com/jquery-2.1.3.min.js'></script>
				<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js'></script>
				<title>$prog</title>
			</head>";
		my $body =
		"<body>
			<div class='container' style = 'margin-top: 20px'>
			<h2 style ='text-align: center'>$prog</h2>";
		my $img = "</div>
		<div >
			<img src=\"$prog.png\" style='display: block; margin-left: auto; margin-right: auto;'>
		</div>";
		my $footer = "</body><html>";

		my $html_file = "Charts/TotalIDs/$prog.html";
		open(my $fh, '>', $html_file) or die "Could not open file '$html_file' $!";
		print $fh $header, $body, $table->getTable, $img, $footer;
		close $fh;
	}
}

elsif ($argoption eq "-chartstotaltools") {
	mkdir "Charts/TotalTools" unless(-d "Charts/TotalTools");

	my %tools_info = ();
	$tools_info{1}{name}  = "cmake";
	$tools_info{1}{ids} = [6,14,23,26];
	$tools_info{2}{name}  = "qmake";
	$tools_info{2}{ids} = [9,15,18];
	$tools_info{3}{name}  = "qbs";
	$tools_info{3}{ids} = [11,20];
	$tools_info{4}{name}  = "netbeans";
	$tools_info{4}{ids} = [6,19];
	$tools_info{5}{name}  = "codeblocks";
	$tools_info{5}{ids} = [1];
	$tools_info{6}{name}  = "clion";
	$tools_info{6}{ids} = [6,14,23,26];
	$tools_info{7}{name}  = "codelite";
	$tools_info{7}{ids} = [8,16];
	$tools_info{8}{name}  = "eclipse";
	$tools_info{8}{ids} = [7,24];
	$tools_info{9}{name}  = "kdevelop";
	$tools_info{9}{ids} = [6,14,23,26];
	$tools_info{10}{name}  = "geany";
	$tools_info{10}{ids} = [2];
	$tools_info{11}{name}  = "anjuta";
	$tools_info{11}{ids} = [1,3,4,19];
	$tools_info{12}{name}  = "qt";
	$tools_info{12}{ids} = [6,9,11,14,15,18,20,23,26];
	$tools_info{13}{name}  = "dialogblocks";
	$tools_info{13}{ids} = [12,17];
	$tools_info{14}{name}  = "zinjai";
	$tools_info{14}{ids} = [10,22];
	$tools_info{15}{name}  = "gps";
	$tools_info{15}{ids} = [1,13,19,25];
	$tools_info{16}{name}  = "oracle";
	$tools_info{16}{ids} = [6,19];
	$tools_info{17}{name}  = "sphere";
	$tools_info{17}{ids} = [21];
	$tools_info{18}{name}  = "cloud9";
	$tools_info{18}{ids} = [1,5];

	#Only Default Profiles
	#$tools_info{1}{name}  = "cmake";
	#$tools_info{1}{ids} = [6];
	#$tools_info{2}{name}  = "qmake";
	#$tools_info{2}{ids} = [9];
	#$tools_info{3}{name}  = "qbs";
	#$tools_info{3}{ids} = [11];
	#$tools_info{4}{name}  = "netbeans";
	#$tools_info{4}{ids} = [6];
	#$tools_info{5}{name}  = "codeblocks";
	#$tools_info{5}{ids} = [1];
	#$tools_info{6}{name}  = "clion";
	#$tools_info{6}{ids} = [6];
	#$tools_info{7}{name}  = "codelite";
	#$tools_info{7}{ids} = [8];
	#$tools_info{8}{name}  = "eclipse";
	#$tools_info{8}{ids} = [7];
	#$tools_info{9}{name}  = "kdevelop";
	#$tools_info{9}{ids} = [6];
	#$tools_info{10}{name}  = "geany";
	#$tools_info{10}{ids} = [2];
	#$tools_info{11}{name}  = "anjuta";
	#$tools_info{11}{ids} = [1];
	#$tools_info{12}{name}  = "qt";
	#$tools_info{12}{ids} = [9];
	#$tools_info{13}{name}  = "dialogblocks";
	#$tools_info{13}{ids} = [12];
	#$tools_info{14}{name}  = "zinjai";
	#$tools_info{14}{ids} = [10];
	#$tools_info{15}{name}  = "gps";
	#$tools_info{15}{ids} = [1];
	#$tools_info{16}{name}  = "oracle";
	#$tools_info{16}{ids} = [6];
	#$tools_info{17}{name}  = "sphere";
	#$tools_info{17}{ids} = [21];
	#$tools_info{18}{name}  = "cloud9";
	#$tools_info{18}{ids} = [5];

	for my $prog (@folders_progs) {

		chomp $prog;
		my @tools = ();
		my @time_values = ();
		my @cpu_values = ();
		my @memory_values = ();

		foreach my $tool ( sort { $a <=> $b } keys %tools_info) {
			my $total_profiles = 0;
			$tools_info{$tool}{$prog}{time_total} = 0;
			$tools_info{$tool}{$prog}{cpu_total} = 0;
			$tools_info{$tool}{$prog}{memory_total} = 0;
			foreach my $profile (sort { $a <=> $b } @{$tools_info{$tool}{ids}}) {		
				$tools_info{$tool}{$prog}{time_total} += $info_ids{$prog}{$profile}{time_mean};							
				$tools_info{$tool}{$prog}{cpu_total} += $info_ids{$prog}{$profile}{cpu_mean};				
				$tools_info{$tool}{$prog}{memory_total} += $info_ids{$prog}{$profile}{memory_mean};				
				$total_profiles++;			
			}
			$tools_info{$tool}{total_profiles} = $total_profiles;
			$tools_info{$tool}{$prog}{time_total_divided} = sprintf("%.3f", ($tools_info{$tool}{$prog}{time_total}/ $tools_info{$tool}{total_profiles}));
			$tools_info{$tool}{$prog}{cpu_total_divided} = sprintf("%.3f", ($tools_info{$tool}{$prog}{cpu_total}/ $tools_info{$tool}{total_profiles}));
			$tools_info{$tool}{$prog}{memory_total_divided} = sprintf("%.3f", ($tools_info{$tool}{$prog}{memory_total}/ $tools_info{$tool}{total_profiles}));
		}

		for my $tool (sort { $a <=> $b } keys %tools_info) {
			push @time_values, $tools_info{$tool}{$prog}{time_total_divided};
			push @cpu_values, $tools_info{$tool}{$prog}{cpu_total_divided};
			push @memory_values, $tools_info{$tool}{$prog}{memory_total_divided};
			push @tools, $tool;
			#push @tools, $tools_info{$tool}{name};
		}
		
		my $max_energy = max(@cpu_values) + max(@memory_values);
		my $max_time = max(@time_values);

		#
		# TABELA
		#
		my $table = new HTML::Table(
			-class=>'table table-bordered table table-hover',
			-style=>'text-align:center; max-width: 600px; margin-left:auto; margin-right:auto;',
		);

		$table -> addRow("Tools", @tools);
		$table -> setRowClass(1, 'active');
		$table -> addRow("Time (s)", @time_values);
		$table -> addRow("CPU (J)", @cpu_values);
		$table -> addRow("Memory (J)", @memory_values);

		#
		# GRAFICO
		#
		my $chart = Chart::Gnuplot->new(
		    output  => "Charts/TotalTools/$prog.png",
		    title   => 'Consumption Values',
		    xlabel  => "Tools",
		    ylabel  => 'Energy (J)',
		    y2label => 'Time (s)',
		    bg      => { 
				 color   => "#c9c9ff", 
				 density => 0.3 
		   	},
		   	grid    => "on",
		   	bmargin => 6,
		    legend  => {
		        position => "outside center bottom",
		        order    => "horizontal reverse",
		        width  => 2,
		        height => 0.5,
		        border   => 'on',
	    	},
		    yrange  => [0, $max_energy+$max_energy*0.10],
		    y2range => [0, $max_time+$max_time*0.10],
		    xtics   => { mirror => 'off' },
		    ytics   => { mirror => 'off' },
		    y2tics  => 'on',
		    "style histogram" => "rowstacked",
		);

		my $memory_bar = Chart::Gnuplot::DataSet->new(
		    xdata => \@tools,
		    ydata => \@memory_values,
		    title => "MEMORY",
		    color => "#525bc3",
		    fill  => {density => 0.3},
		    style => "histograms",
		);

		my $cpu_bar = Chart::Gnuplot::DataSet->new(
		    xdata => \@tools,
		    ydata => \@cpu_values,
		    title => "CPU",
		    color => "#ff0000",	    
		    fill  => {density => 0.3},
		    style => "histograms",
		);

		#necessary to print the line from the positions 0-25 and not 1-26 (ids numbers)
		my $size = (scalar @tools);
		my @toolsaux = (0..$size-1);

		my $time_line = Chart::Gnuplot::DataSet->new(
			xdata  => \@toolsaux,
		    ydata  => \@time_values,
		  	color => "#000000",
		  	title  => "TIME",
		 	style  => 'lines',
		  	axes   => 'x1y2',
		);

		$chart->plot2d($cpu_bar, $memory_bar, $time_line);

		#HTML	
		my $header = 
		"<!DOCTYPE html>
		<html>
			<head>
				<link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css' rel='stylesheet'>
				<script src='https://code.jquery.com/jquery-2.1.3.min.js'></script>
				<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js'></script>
				<title>$prog</title>
			</head>";
		my $body =
		"<body>
			<div class='container' style = 'margin-top: 20px'>
			<h2 style ='text-align: center'>$prog</h2>";
		my $img = "</div>
		<div >
			<img src=\"$prog.png\" style='display: block; margin-left: auto; margin-right: auto;'>
		</div>";
		my $footer = "</body><html>";

		my $html_file = "Charts/TotalTools/$prog.html";
		open(my $fh, '>', $html_file) or die "Could not open file '$html_file' $!";
		print $fh $header, $body, $table->getTable, $img, $footer;
		close $fh;
	}
}

elsif ($argoption eq "-chartscategories") {
	mkdir "Charts/Categories" unless(-d "Charts/Categories");
	my %categories = ();
	$categories{1}{name} = "Empty";
	$categories{1}{values} = [1];
	$categories{2}{name} = "Warnings";
	$categories{2}{values} = [2];
	$categories{3}{name} = "Debug without warnings";
	$categories{3}{values} = [3,4,6];
	$categories{4}{name} = "Debug with warnings";
	$categories{4}{values} = [5,7,8,9,10,11,12];
	$categories{5}{name} = "Low Level Optimization";
	$categories{5}{values} = [13];
	$categories{6}{name} = "Optimization with Debug";
	$categories{6}{values} = [14,15];
	$categories{7}{name} = "Recommended Optimization";
	$categories{7}{values} = [16,17,18,19,20,21,22];
	$categories{8}{name} = "High Level Optimization";
	$categories{8}{values} = [23, 24, 25];
	$categories{9}{name} = "Code Size Optimization";
	$categories{9}{values} = [26];		
	##########################################################
	$categories{10}{name} = "Without Debug and Optimizations";
	$categories{10}{values} = [1,2];
	$categories{11}{name} = "Debug without Optimizations";
	$categories{11}{values} = [3,4,5,6,7,8,9,10,11,12];	
	$categories{12}{name} = "Optimizations with Debug";
	$categories{12}{values} = [14,15];		
	$categories{13}{name} = "Optimizations without Debug";
	$categories{13}{values} = [13,16,17,18,19,20,21,22,23,24,25,26];	
	##########################################################	

	for my $prog (@folders_progs) {

		chomp $prog;
		mkdir "Charts/Categories/$prog" unless(-d "Charts/Categories/$prog");		
		for my $category (keys %categories) {

			my %info_ids_categories = ();
			foreach my $profile (@{$categories{$category}{values}}) {
				$info_ids_categories{$prog}{$profile} = $info_ids{$prog}{$profile};
			}

			my @profiles = ();
			my @time_values = ();
			my @cpu_values = ();
			my @memory_values = ();

			for my $profile (sort { $a <=> $b } keys %{$info_ids_categories{$prog}}) {
				push @time_values, $info_ids{$prog}{$profile}{time_mean};
				push @cpu_values, $info_ids{$prog}{$profile}{cpu_mean};
				push @memory_values, $info_ids{$prog}{$profile}{memory_mean};
				push @profiles, $profile;
			}
			
			my $max_energy = max(@cpu_values) + max(@memory_values);
			my $max_time = max(@time_values);

			#
			# TABELA
			#
			my $table = new HTML::Table(
				-class=>'table table-bordered table table-hover',
				-style=>'text-align:center; max-width: 600px; margin-left:auto; margin-right:auto;',
			);

			$table -> addRow("Profiles", @profiles);
			$table -> setRowClass(1, 'active');
			$table -> addRow("Time (s)", @time_values);
			$table -> addRow("CPU (J)", @cpu_values);
			$table -> addRow("Memory (J)", @memory_values);

			#
			# GRAFICO
			#
			my $chart = Chart::Gnuplot->new(
			    output  => "Charts/Categories/$prog/$category.png",
			    title   => 'Consumption Values',
			    xlabel  => "Profiles IDs",
			    ylabel  => 'Energy (J)',
			    y2label => 'Time (s)',
			    bg      => { 
					 color   => "#c9c9ff", 
					 density => 0.3 
			   	},
			   	grid    => "on",
			   	bmargin => 6,
			    legend  => {
			        position => "outside center bottom",
			        order    => "horizontal reverse",
			        width  => 2,
			        height => 0.5,
			        border   => 'on',
		    	},
			    yrange  => [0, $max_energy+$max_energy*0.10],
			    y2range => [0, $max_time+$max_time*0.10],
			    xtics   => { mirror => 'off' },
			    ytics   => { mirror => 'off' },
			    y2tics  => 'on',
			    "style histogram" => "rowstacked",
			);

			my $memory_bar = Chart::Gnuplot::DataSet->new(
			    xdata => \@profiles,
			    ydata => \@memory_values,
			    title => "MEMORY",
			    color => "#525bc3",
			    fill  => {density => 0.3},
			    style => "histograms",
			);

			my $cpu_bar = Chart::Gnuplot::DataSet->new(
			    xdata => \@profiles,
			    ydata => \@cpu_values,
			    title => "CPU",
			    color => "#ff0000",	    
			    fill  => {density => 0.3},
			    style => "histograms",
			);

			#necessary to print the line from the positions 0-25 and not 1-26 (ids numbers)
			my $size = (scalar @profiles);
			my @profilesaux = (0..$size-1);

			my $time_line = Chart::Gnuplot::DataSet->new(
				xdata  => \@profilesaux,
			    ydata  => \@time_values,
			  	color => "#000000",
			  	title  => "TIME",
			 	style  => 'lines',
			  	axes   => 'x1y2',
			);

			$chart->plot2d($cpu_bar, $memory_bar, $time_line);

			#HTML	
			my $header = 
			"<!DOCTYPE html>
			<html>
				<head>
					<link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css' rel='stylesheet'>
					<script src='https://code.jquery.com/jquery-2.1.3.min.js'></script>
					<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js'></script>
					<title>$prog - $categories{$category}{name}</title>
				</head>";
			my $body =
			"<body>
				<div class='container' style = 'margin-top: 20px'>
				<h2 style ='text-align: center'>$prog - $categories{$category}{name}</h2>";
			my $img = "</div>
			<div >
				<img src=\"$category.png\" style='display: block; margin-left: auto; margin-right: auto;'>
			</div>";
			my $footer = "</body><html>";

			my $html_file = "Charts/Categories/$prog/$category.html";
			open(my $fh, '>', $html_file) or die "Could not open file '$html_file' $!";
			print $fh $header, $body, $table->getTable, $img, $footer;
			close $fh;
		}
	}
}

#
# RANKINGS
#
elsif ($argoption eq "-rankprogs") {
	mkdir "Rankings" unless(-d "Rankings");	
	mkdir "Rankings/progs" unless(-d "Rankings/progs");	

	my $table = "";
	open(my $fhprogs, '>', "Rankings/progs.txt") or die "Could not open file 'progs' $!";

	for my $prog (@folders_progs) {

		chomp $prog;
		my $ranking_time_mean = 0;
		my $ranking_energy_mean = 0;
		my $ranking_cpu_mean = 0;
		my $ranking_memory_mean = 0;
		my $ranking_energytime_mean = 0;

		my @sorted_profile_time_mean = sort {$info_ids{$prog}{$a}{time_mean} <=> $info_ids{$prog}{$b}{time_mean}} keys %{$info_ids{$prog}};
		my @sorted_profile_energy_mean = sort {($info_ids{$prog}{$a}{cpu_mean} + $info_ids{$prog}{$a}{memory_mean}) <=> ($info_ids{$prog}{$b}{cpu_mean} + $info_ids{$prog}{$b}{memory_mean})} keys %{$info_ids{$prog}};
		my @sorted_profile_cpu_mean = sort {$info_ids{$prog}{$a}{cpu_mean} <=> $info_ids{$prog}{$b}{cpu_mean}} keys %{$info_ids{$prog}};
		my @sorted_profile_memory_mean = sort {$info_ids{$prog}{$a}{memory_mean} <=> $info_ids{$prog}{$b}{memory_mean}} keys %{$info_ids{$prog}};
		my @sorted_profile_joule_sec = sort {(($info_ids{$prog}{$a}{cpu_mean} + $info_ids{$prog}{$a}{memory_mean})/($info_ids{$prog}{$a}{time_mean})) 
												<=> (($info_ids{$prog}{$b}{cpu_mean} + $info_ids{$prog}{$b}{memory_mean})/($info_ids{$prog}{$b}{time_mean}))} keys %{$info_ids{$prog}};

		open(my $fh, '>', "Rankings/progs/".$prog.".txt") or die "Could not open file '$prog' $!";
		print $fh "$prog\n";

		print $fh "\tSort by Time\n";
		for my $profile (@sorted_profile_time_mean) {
			print $fh "\t\t".$profile.": ".  $info_ids{$prog}{$profile}{time_mean}."\n";
			$ranking_time_mean += $info_ids{$prog}{$profile}{time_mean};
		}
		print $fh "\tMean: ".sprintf("%.3f", ($ranking_time_mean/26))."\n\n";

		print $fh "\tSort by Energy\n";
		for my $profile (@sorted_profile_energy_mean) {
			print $fh "\t\t".$profile.": ". ($info_ids{$prog}{$profile}{cpu_mean}+$info_ids{$prog}{$profile}{memory_mean}) ."\n";
			$ranking_energy_mean += ($info_ids{$prog}{$profile}{cpu_mean}+$info_ids{$prog}{$profile}{memory_mean});
		}
		print $fh "\tMean: ".sprintf("%.3f", ($ranking_energy_mean/26))."\n\n";

		print $fh "\tSort by CPU\n";
		for my $profile (@sorted_profile_cpu_mean) {
			print $fh "\t\t".$profile.": ".  $info_ids{$prog}{$profile}{cpu_mean}."\n";
			$ranking_cpu_mean += $info_ids{$prog}{$profile}{cpu_mean};
		}
		print $fh "\tMean: ".sprintf("%.3f", ($ranking_cpu_mean/26))."\n\n";

		print $fh "\tSort by Memory\n";
		for my $profile (@sorted_profile_memory_mean) {
			print $fh "\t\t".$profile.": ". $info_ids{$prog}{$profile}{memory_mean}."\n";
			$ranking_memory_mean += $info_ids{$prog}{$profile}{memory_mean};
		}
		print $fh "\tMean: ".sprintf("%.3f", ($ranking_memory_mean/26))."\n\n";

		print $fh "\tSort by Energy/Time\n";
		for my $profile (@sorted_profile_joule_sec) {
			print $fh "\t\t".$profile.": ". sprintf("%.3f", (($info_ids{$prog}{$profile}{cpu_mean} + $info_ids{$prog}{$profile}{memory_mean})/($info_ids{$prog}{$profile}{time_mean}))) ."\n";
			$ranking_energytime_mean += (($info_ids{$prog}{$profile}{cpu_mean} + $info_ids{$prog}{$profile}{memory_mean})/($info_ids{$prog}{$profile}{time_mean}));
		}
		print $fh "\tMean: ".sprintf("%.3f", (($ranking_energytime_mean/26)))."\n\n";
		close $fh;

		#
		# Total Ranking
		#
		my $time_min = $info_ids{$prog}{$sorted_profile_time_mean[0]}{time_mean};
		my $time_max = $info_ids{$prog}{$sorted_profile_time_mean[-1]}{time_mean};
		my $time_mean = $ranking_time_mean/26;

		print $fhprogs "$prog\n";
		print $fhprogs "\tTime: ";
		print $fhprogs $time_min ." - ";
		print $fhprogs $time_max ." ";
		print $fhprogs "(". sprintf("%.3f", $time_mean) .")\n";

		my $energy_min = $info_ids{$prog}{$sorted_profile_energy_mean[0]}{cpu_mean} + $info_ids{$prog}{$sorted_profile_energy_mean[0]}{memory_mean};
		my $energy_max = $info_ids{$prog}{$sorted_profile_energy_mean[-1]}{cpu_mean} + $info_ids{$prog}{$sorted_profile_energy_mean[-1]}{memory_mean};
		my $energy_mean = $ranking_energy_mean/26;

		print $fhprogs "\tEnergy: ";
		print $fhprogs $energy_min ." - ";
		print $fhprogs $energy_max." ";
		print $fhprogs "(". sprintf("%.3f", $energy_mean) .")\n";

		my $cpu_min = $info_ids{$prog}{$sorted_profile_cpu_mean[0]}{cpu_mean};
		my $cpu_max = $info_ids{$prog}{$sorted_profile_cpu_mean[-1]}{cpu_mean};
		my $cpu_mean = $ranking_cpu_mean/26;

		print $fhprogs "\tCPU: ";
		print $fhprogs $cpu_min ." - ";
		print $fhprogs $cpu_max ." ";
		print $fhprogs "(". sprintf("%.3f", $cpu_mean) .")\n";

		my $memory_min = $info_ids{$prog}{$sorted_profile_memory_mean[0]}{memory_mean};
		my $memory_max = $info_ids{$prog}{$sorted_profile_memory_mean[-1]}{memory_mean};
		my $memory_mean = $ranking_memory_mean/26;

		print $fhprogs "\tMemory: ";
		print $fhprogs $memory_min ." - ";
		print $fhprogs $memory_max ." ";
		print $fhprogs "(". sprintf("%.3f", $memory_mean) .")\n";

		my $energytime_min = ($info_ids{$prog}{$sorted_profile_joule_sec[0]}{cpu_mean} + $info_ids{$prog}{$sorted_profile_joule_sec[0]}{memory_mean})/$info_ids{$prog}{$sorted_profile_joule_sec[0]}{time_mean};
		my $energytime_max = ($info_ids{$prog}{$sorted_profile_joule_sec[-1]}{cpu_mean} + $info_ids{$prog}{$sorted_profile_joule_sec[-1]}{memory_mean})/$info_ids{$prog}{$sorted_profile_joule_sec[-1]}{time_mean};
		my $energytime_mean = $ranking_energytime_mean/26;

		#
		# Total Ranking Table
		#
		$table = join ("", $table, $prog ."\t&\\makecell{");
		$table = join ("", $table, $time_min ."-");
		$table = join ("", $table, $time_max ."\\\\");
		$table = join ("", $table, sprintf("%.1f", ($time_max-$time_min)*100/$time_max) ." \\% \\\\");
		$table = join ("", $table, "(". sprintf("%.3f", $time_mean).")");
		$table = join ("", $table, "}\t&\\makecell{");
		$table = join ("", $table, $energy_min ."-");
		$table = join ("", $table, $energy_max ."\\\\");
		$table = join ("", $table, sprintf("%.1f", ($energy_max-$energy_min)*100/$energy_max) ." \\% \\\\");
		#$table = join ("", $table, sprintf("%.1f", (($time_max-$time_min)*100/ $time_max)-(($energy_max-$energy_min)*100/ $energy_max))." \\% \\\\");
		$table = join ("", $table, "(". sprintf("%.3f", $energy_mean));
		$table = join ("", $table, ")}\t&\\makecell{");
		$table = join ("", $table, $cpu_min ."-");
		$table = join ("", $table, $cpu_max ."\\\\");
		$table = join ("", $table, sprintf("%.1f", ($cpu_max-$cpu_min)*100/$cpu_max) ." \\% \\\\");
		$table = join ("", $table, "(". sprintf("%.3f", $cpu_mean) .")\\\\");
		#$table = join ("", $table, sprintf("%.1f", ($cpu_mean*100/$energy_mean)). "" \\%"");	
		$table = join ("", $table, "}\t&\\makecell{");
		$table = join ("", $table, $memory_min ."-");
		$table = join ("", $table, $memory_max ."\\\\");
		$table = join ("", $table, sprintf("%.1f", ($memory_max-$memory_min)*100/$memory_max) ." \\% \\\\");
		$table = join ("", $table, "(". sprintf("%.3f", $memory_mean) .")\\\\");
		#$table = join ("", $table, sprintf("%.1f", ($memory_mean*100/$energy_mean)));
		$table = join ("", $table, "}\t&\\makecell{");
		$table = join ("", $table, sprintf("%.3f", $energytime_min) ."-");
		$table = join ("", $table, sprintf("%.3f", $energytime_max) ."\\\\");
		$table = join ("", $table, sprintf("%.1f", ($energytime_max-$energytime_min)*100/$energytime_max) ." \\% \\\\");
		$table = join ("", $table, "(". sprintf("%.3f", $energytime_mean) .")}\\\\\\hline\n");
	}

	my $table_header = "\\thead{\\textbf{Program}} & \\thead{\\textbf{Time (s)}} & \\thead{\\textbf{Energy (J)}} & \\thead{\\textbf{CPU (J)}} & \\thead{\\textbf{Memory (J)}}  & \\thead{\\textbf{Energy/Time (J/s)}}\\\\\\hline";
	print $fhprogs "\nLaTeX Table\n". $table_header ."\n" . $table ."\n\n"; 
	close $fhprogs;
}

elsif ($argoption eq "-rankids") {	
	mkdir "Rankings" unless(-d "Rankings");	

	open(my $fh, '>', "Rankings/rankids.txt") or die "Could not open file 'rankids' $!";
	for(my $point = 0; $point < 4; $point++) {

		my @sorted_profile_time_mean = ();
		my @sorted_profile_energy_mean = ();
		my @sorted_profile_cpu_mean = ();
		my @sorted_profile_memory_mean = ();
		my @sorted_profile_joulesec = ();

		print $fh "Profiles ranked with ". $point . " decimal points\n";
		my %ranking_profiles = ();

		#Individual Ranking for each program
		for my $prog (@folders_progs) {
			chomp $prog;

			@sorted_profile_time_mean = sort {$info_ids{$prog}{$a}{time_mean} <=> $info_ids{$prog}{$b}{time_mean}} keys %{$info_ids{$prog}};
			@sorted_profile_energy_mean = sort {($info_ids{$prog}{$a}{cpu_mean} + $info_ids{$prog}{$a}{memory_mean}) <=> ($info_ids{$prog}{$b}{cpu_mean} + $info_ids{$prog}{$b}{memory_mean})} keys %{$info_ids{$prog}};
			@sorted_profile_cpu_mean = sort {$info_ids{$prog}{$a}{cpu_mean} <=> $info_ids{$prog}{$b}{cpu_mean}} keys %{$info_ids{$prog}};
			@sorted_profile_memory_mean = sort {$info_ids{$prog}{$a}{memory_mean} <=> $info_ids{$prog}{$b}{memory_mean}} keys %{$info_ids{$prog}};
			@sorted_profile_joulesec = sort {(($info_ids{$prog}{$a}{cpu_mean} + $info_ids{$prog}{$a}{memory_mean})/($info_ids{$prog}{$a}{time_mean})) 
													<=> (($info_ids{$prog}{$b}{cpu_mean} + $info_ids{$prog}{$b}{memory_mean})/($info_ids{$prog}{$b}{time_mean}))} keys %{$info_ids{$prog}};

			my $pos = 0; my $last_value = 0;
			my $total_profiles = scalar @sorted_profile_time_mean;
			for (my $i=0; $i < $total_profiles; $i++) {
				my $profile_id = $sorted_profile_time_mean[$i];
				my $present_value = sprintf("%.".$point."f", $info_ids{$prog}{$profile_id}{time_mean});
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{time}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_profiles; $i++) {
				my $profile_id = $sorted_profile_energy_mean[$i];
				my $present_value = sprintf("%.".$point."f", ($info_ids{$prog}{$profile_id}{cpu_mean} + $info_ids{$prog}{$profile_id}{memory_mean}));
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{energy}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_profiles; $i++) {
				my $profile_id = $sorted_profile_cpu_mean[$i];
				my $present_value = sprintf("%.".$point."f", $info_ids{$prog}{$profile_id}{cpu_mean});
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{cpu}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_profiles; $i++) {
				my $profile_id = $sorted_profile_memory_mean[$i];
				my $present_value = sprintf("%.".$point."f", $info_ids{$prog}{$profile_id}{memory_mean});
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{memory}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_profiles; $i++) {
				my $profile_id = $sorted_profile_joulesec[$i];
				my $present_value = sprintf("%.".$point."f", ($info_ids{$prog}{$profile_id}{cpu_mean} + $info_ids{$prog}{$profile_id}{memory_mean})/($info_ids{$prog}{$profile_id}{time_mean}));
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{joulesec}}, $pos;
			}

			foreach my $id (keys %ranking_profiles) {
				$ranking_profiles{$id}{time_total} = (eval join '+', @{$ranking_profiles{$id}{time}});
				$ranking_profiles{$id}{energy_total} = (eval join '+', @{$ranking_profiles{$id}{energy}});
				$ranking_profiles{$id}{cpu_total} = (eval join '+', @{$ranking_profiles{$id}{cpu}});
				$ranking_profiles{$id}{memory_total} = (eval join '+', @{$ranking_profiles{$id}{memory}});
				$ranking_profiles{$id}{joulesec_total} = (eval join '+', @{$ranking_profiles{$id}{joulesec}});			
			}
		}

		#Global Ranking for all profiles
		my $pos = 1; my $last_value = 0;
		print $fh "\t Time Ranking:\n";
		for my $profile (sort { $ranking_profiles{$a}{time_total} <=> $ranking_profiles{$b}{time_total} } keys %ranking_profiles) {
			if ($last_value == $ranking_profiles{$profile}{time_total}) {
				print $fh "\t\t  : " . $profile . "(" . $ranking_profiles{$profile}{time_total} . ")\n";
				$ranking_profiles{$profile}{time_total_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $profile . "(" . $ranking_profiles{$profile}{time_total} . ")\n";
				$ranking_profiles{$profile}{time_total_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_profiles{$profile}{time_total};		
		}
		print $fh ("\n\n");

		$pos = 1; $last_value = 0;
		print $fh "\t Energy Ranking:\n";
		for my $profile (sort { $ranking_profiles{$a}{energy_total} <=> $ranking_profiles{$b}{energy_total} } keys %ranking_profiles) {			
			if ($last_value == $ranking_profiles{$profile}{energy_total}) {
				print $fh "\t\t  : " . $profile . "(" . $ranking_profiles{$profile}{energy_total} . ")\n";
				$ranking_profiles{$profile}{energy_total_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $profile . "(" . $ranking_profiles{$profile}{energy_total} . ")\n";
				$ranking_profiles{$profile}{energy_total_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_profiles{$profile}{energy_total};		
		}
		print $fh ("\n\n");

		$pos = 1; $last_value = 0;
		print $fh "\t CPU Ranking:\n";
		for my $profile (sort { $ranking_profiles{$a}{cpu_total} <=> $ranking_profiles{$b}{cpu_total} } keys %ranking_profiles) {			
			if ($last_value == $ranking_profiles{$profile}{cpu_total}) {
				print $fh "\t\t  : " . $profile . "(" . $ranking_profiles{$profile}{cpu_total} . ")\n";
				$ranking_profiles{$profile}{cpu_total_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $profile . "(" . $ranking_profiles{$profile}{cpu_total} . ")\n";
				$ranking_profiles{$profile}{cpu_total_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_profiles{$profile}{cpu_total};		
		}
		print $fh ("\n\n");

		$pos = 1; $last_value = 0;
		print $fh "\t Memory Ranking:\n";
		for my $profile (sort { $ranking_profiles{$a}{memory_total} <=> $ranking_profiles{$b}{memory_total} } keys %ranking_profiles) {			
			if ($last_value == $ranking_profiles{$profile}{memory_total}) {
				print $fh "\t\t  : " . $profile . "(" . $ranking_profiles{$profile}{memory_total} . ")\n";
				$ranking_profiles{$profile}{memory_total_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $profile . "(" . $ranking_profiles{$profile}{memory_total} . ")\n";
				$ranking_profiles{$profile}{memory_total_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_profiles{$profile}{memory_total};		
		}
		print $fh ("\n\n");

		$pos = 1; $last_value = 0;
		print $fh "\t Energy/Time Ranking:\n";
		for my $profile (sort { $ranking_profiles{$a}{joulesec_total} <=> $ranking_profiles{$b}{joulesec_total} } keys %ranking_profiles) {			
			if ($last_value == $ranking_profiles{$profile}{joulesec_total}) {
				print $fh "\t\t  : " . $profile . "(" . $ranking_profiles{$profile}{joulesec_total} . ")\n";
				$ranking_profiles{$profile}{joulesec_total_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $profile . "(" . $ranking_profiles{$profile}{joulesec_total} . ")\n";
				$ranking_profiles{$profile}{joulesec_total_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_profiles{$profile}{joulesec_total};		
		}
		print $fh ("\n\n");

		#
		# Total Ranking Table
		#		
		my $table = "";
		my $table_header = "\\thead{\\textbf{Profile ID}} & \\thead{\\textbf{Execution Time \\scriptsize(s)}} & \\thead{\\textbf{Total Energy \\scriptsize(J)}} & \\thead{\\textbf{CPU Energy \\scriptsize(J)}} & \\thead{\\textbf{Memory Energy \\scriptsize(J)}} & \\thead{\\textbf{Energy/Time \\scriptsize(J/s)}}\\\\\\hline";
		for my $profile ( sort {$a <=> $b} keys %ranking_profiles) {
			$table = join ("", $table, $profile ."\t&\t");
			$table = join ("", $table, $ranking_profiles{$profile}{time_total_pos}{$point} . " \\scriptsize(" . $ranking_profiles{$profile}{time_total} . ")". "\t&\t");
			$table = join ("", $table, $ranking_profiles{$profile}{energy_total_pos}{$point} . " \\scriptsize(" . $ranking_profiles{$profile}{energy_total} . ")" . "\t&\t");
			$table = join ("", $table, $ranking_profiles{$profile}{cpu_total_pos}{$point} . " \\scriptsize(" . $ranking_profiles{$profile}{cpu_total} . ")" . "\t&\t");
			$table = join ("", $table, $ranking_profiles{$profile}{memory_total_pos}{$point} . " \\scriptsize(" . $ranking_profiles{$profile}{memory_total} . ")" . "\t&\t");
			$table = join ("", $table, $ranking_profiles{$profile}{joulesec_total_pos}{$point} . " \\scriptsize(" . $ranking_profiles{$profile}{joulesec_total} . ")" . "\\\\\\hline\n");
		}
		print $fh "\nLaTeX Table\n". $table_header . "\n" . $table ."\n\n"; 
	}
	close $fh;
}


elsif ($argoption eq "-ranktools") {	

	my %tools = ();
	$tools{1}{name}  = "cmake";
	$tools{1}{ids} = [6,14,23,26];
	$tools{2}{name}  = "qmake";
	$tools{2}{ids} = [9,15,18];
	$tools{3}{name}  = "qbs";
	$tools{3}{ids} = [11,20];
	$tools{4}{name}  = "netbeans";
	$tools{4}{ids} = [6,19];
	$tools{5}{name}  = "codeblocks";
	$tools{5}{ids} = [1];
	$tools{6}{name}  = "clion";
	$tools{6}{ids} = [6,14,23,26];
	$tools{7}{name}  = "codelite";
	$tools{7}{ids} = [8,16];
	$tools{8}{name}  = "eclipse";
	$tools{8}{ids} = [7,24];
	$tools{9}{name}  = "kdevelop";
	$tools{9}{ids} = [6,14,23,26];
	$tools{10}{name}  = "geany";
	$tools{10}{ids} = [2];
	$tools{11}{name}  = "anjuta";
	$tools{11}{ids} = [1,3,4,19];
	$tools{12}{name}  = "qt";
	$tools{12}{ids} = [6,9,11,14,15,18,20,23,26];
	$tools{13}{name}  = "dialogblocks";
	$tools{13}{ids} = [12,17];
	$tools{14}{name}  = "zinjai";
	$tools{14}{ids} = [10,22];
	$tools{15}{name}  = "gps";
	$tools{15}{ids} = [1,13,19,25];
	$tools{16}{name}  = "oracle";
	$tools{16}{ids} = [6,19];
	$tools{17}{name}  = "sphere";
	$tools{17}{ids} = [21];
	$tools{18}{name}  = "cloud9";
	$tools{18}{ids} = [1,5];

	#Only Default Profiles
	#$tools{1}{name}  = "cmake";
	#$tools{1}{ids} = [6];
	#$tools{2}{name}  = "qmake";
	#$tools{2}{ids} = [9];
	#$tools{3}{name}  = "qbs";
	#$tools{3}{ids} = [11];
	#$tools{4}{name}  = "netbeans";
	#$tools{4}{ids} = [6];
	#$tools{5}{name}  = "codeblocks";
	#$tools{5}{ids} = [1];
	#$tools{6}{name}  = "clion";
	#$tools{6}{ids} = [6];
	#$tools{7}{name}  = "codelite";
	#$tools{7}{ids} = [8];
	#$tools{8}{name}  = "eclipse";
	#$tools{8}{ids} = [7];
	#$tools{9}{name}  = "kdevelop";
	#$tools{9}{ids} = [6];
	#$tools{10}{name}  = "geany";
	#$tools{10}{ids} = [2];
	#$tools{11}{name}  = "anjuta";
	#$tools{11}{ids} = [1];
	#$tools{12}{name}  = "qt";
	#$tools{12}{ids} = [9];
	#$tools{13}{name}  = "dialogblocks";
	#$tools{13}{ids} = [12];
	#$tools{14}{name}  = "zinjai";
	#$tools{14}{ids} = [10];
	#$tools{15}{name}  = "gps";
	#$tools{15}{ids} = [1];
	#$tools{16}{name}  = "oracle";
	#$tools{16}{ids} = [6];
	#$tools{17}{name}  = "sphere";
	#$tools{17}{ids} = [21];
	#$tools{18}{name}  = "cloud9";
	#$tools{18}{ids} = [5];

	my %profiles_tools = ();
	$profiles_tools{1} = [5,11,15,18];
	$profiles_tools{2} = [10];
	$profiles_tools{3} = [11];
	$profiles_tools{4} = [11];
	$profiles_tools{5} = [18];
	$profiles_tools{6} = [1,4,6,9,12,16];
	$profiles_tools{7} = [8];
	$profiles_tools{8} = [7];
	$profiles_tools{9} = [2,12];
	$profiles_tools{10} = [14];
	$profiles_tools{11} = [3,12];
	$profiles_tools{12} = [13];
	$profiles_tools{13} = [15];
	$profiles_tools{14} = [1,6,9,12];
	$profiles_tools{15} = [2,12];
	$profiles_tools{16} = [7];
	$profiles_tools{17} = [13];
	$profiles_tools{18} = [2,12];
	$profiles_tools{19} = [4,11,15,16];
	$profiles_tools{20} = [3,12];
	$profiles_tools{21} = [17];
	$profiles_tools{22} = [14];
	$profiles_tools{23} = [1,6,9,12];
	$profiles_tools{24} = [8];
	$profiles_tools{25} = [15];
	$profiles_tools{26} = [1,6,9,12];

	mkdir "Rankings" unless(-d "Rankings");	
	open(my $fh, '>', "Rankings/ranktools.txt") or die "Could not open file 'ranktools' $!";

	for(my $point = 0; $point < 4; $point++) {

		my @sorted_profile_time_mean = ();
		my @sorted_profile_energy_mean = ();
		my @sorted_profile_cpu_mean = ();
		my @sorted_profile_memory_mean = ();
		my @sorted_profile_joulesec = ();

		print $fh "Tools ranked with ". $point . " decimal points\n";
		my %ranking_profiles = ();
		my %ranking_tools = ();

		#Individual Ranking for each program
		for my $prog (@folders_progs) {
			chomp $prog;

			@sorted_profile_time_mean = sort {$info_ids{$prog}{$a}{time_mean} <=> $info_ids{$prog}{$b}{time_mean}} keys %{$info_ids{$prog}};
			@sorted_profile_energy_mean = sort {($info_ids{$prog}{$a}{cpu_mean} + $info_ids{$prog}{$a}{memory_mean}) <=> ($info_ids{$prog}{$b}{cpu_mean} + $info_ids{$prog}{$b}{memory_mean})} keys %{$info_ids{$prog}};
			@sorted_profile_cpu_mean = sort {$info_ids{$prog}{$a}{cpu_mean} <=> $info_ids{$prog}{$b}{cpu_mean}} keys %{$info_ids{$prog}};
			@sorted_profile_memory_mean = sort {$info_ids{$prog}{$a}{memory_mean} <=> $info_ids{$prog}{$b}{memory_mean}} keys %{$info_ids{$prog}};
			@sorted_profile_joulesec = sort {(($info_ids{$prog}{$a}{cpu_mean} + $info_ids{$prog}{$a}{memory_mean})/($info_ids{$prog}{$a}{time_mean})) 
													<=> (($info_ids{$prog}{$b}{cpu_mean} + $info_ids{$prog}{$b}{memory_mean})/($info_ids{$prog}{$b}{time_mean}))} keys %{$info_ids{$prog}};

			my $pos = 0; my $last_value = 0;
			my $total_ids = scalar @sorted_profile_time_mean;
			for (my $i=0; $i < $total_ids; $i++) {
				my $profile_id = $sorted_profile_time_mean[$i];
				my $present_value = sprintf("%.".$point."f", $info_ids{$prog}{$profile_id}{time_mean});
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{time}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_ids; $i++) {
				my $profile_id = $sorted_profile_energy_mean[$i];
				my $present_value = sprintf("%.".$point."f", ($info_ids{$prog}{$profile_id}{cpu_mean} + $info_ids{$prog}{$profile_id}{memory_mean}));
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{energy}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_ids; $i++) {
				my $profile_id = $sorted_profile_cpu_mean[$i];
				my $present_value = sprintf("%.".$point."f", $info_ids{$prog}{$profile_id}{cpu_mean});
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{cpu}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_ids; $i++) {
				my $profile_id = $sorted_profile_memory_mean[$i];
				my $present_value = sprintf("%.".$point."f", $info_ids{$prog}{$profile_id}{memory_mean});
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{memory}}, $pos;
			}

			$pos = 0; $last_value = 0;
			for (my $i=0; $i < $total_ids; $i++) {
				my $profile_id = $sorted_profile_joulesec[$i];
				my $present_value = sprintf("%.".$point."f", ($info_ids{$prog}{$profile_id}{cpu_mean} + $info_ids{$prog}{$profile_id}{memory_mean})/($info_ids{$prog}{$profile_id}{time_mean}));
				if ($present_value > $last_value) {
					$pos++;
					$last_value = $present_value;
				}
				push @{$ranking_profiles{$profile_id}{joulesec}}, $pos;
			}

			foreach my $id (keys %ranking_profiles) {
				$ranking_profiles{$id}{time_total} = (eval join '+', @{$ranking_profiles{$id}{time}});
				$ranking_profiles{$id}{energy_total} = (eval join '+', @{$ranking_profiles{$id}{energy}});
				$ranking_profiles{$id}{cpu_total} = (eval join '+', @{$ranking_profiles{$id}{cpu}});
				$ranking_profiles{$id}{memory_total} = (eval join '+', @{$ranking_profiles{$id}{memory}});
				$ranking_profiles{$id}{joulesec_total} = (eval join '+', @{$ranking_profiles{$id}{joulesec}});			
			}
		}

		#Preparing tools ranking 
		foreach my $profile_id (keys %ranking_profiles) {
			foreach my $tool_id (@{$profiles_tools{$profile_id}}) {
				$ranking_tools{$tool_id}{$profile_id} = $ranking_profiles{$profile_id};
			}
		}

		foreach my $tool (keys %ranking_tools) {
			my $total_profiles = 0;
			foreach my $profile (keys %{$ranking_tools{$tool}}) {
				$ranking_tools{$tool}{time_total} += $ranking_profiles{$profile}{time_total};				
				$ranking_tools{$tool}{energy_total} += $ranking_profiles{$profile}{energy_total};				
				$ranking_tools{$tool}{cpu_total} += $ranking_profiles{$profile}{cpu_total};				
				$ranking_tools{$tool}{memory_total} += $ranking_profiles{$profile}{memory_total};				
				$ranking_tools{$tool}{joulesec_total} += $ranking_profiles{$profile}{joulesec_total};	
				$total_profiles++;			
			}
			$ranking_tools{$tool}{total_profiles} = $total_profiles;
			$ranking_tools{$tool}{time_total_divided} = sprintf("%.1f", ($ranking_tools{$tool}{time_total}/ $ranking_tools{$tool}{total_profiles}));
			$ranking_tools{$tool}{energy_total_divided} = sprintf("%.1f", ($ranking_tools{$tool}{energy_total}/ $ranking_tools{$tool}{total_profiles}));
			$ranking_tools{$tool}{cpu_total_divided} = sprintf("%.1f", ($ranking_tools{$tool}{cpu_total}/ $ranking_tools{$tool}{total_profiles}));
			$ranking_tools{$tool}{memory_total_divided} = sprintf("%.1f", ($ranking_tools{$tool}{memory_total}/ $ranking_tools{$tool}{total_profiles}));
			$ranking_tools{$tool}{joulesec_total_divided} = sprintf("%.1f", ($ranking_tools{$tool}{joulesec_total}/ $ranking_tools{$tool}{total_profiles}));
		}

		#Global Ranking for all tools
		my $pos = 1; my $last_value = 0;
		print $fh "\t Time Ranking:\n";
		for my $tool (sort { $ranking_tools{$a}{time_total_divided} <=> $ranking_tools{$b}{time_total_divided} } keys %ranking_tools) {
			if ($last_value == $ranking_tools{$tool}{time_total_divided}) {
				print $fh "\t\t  : " . $tools{$tool}{name} . " (" . $ranking_tools{$tool}{time_total_divided} . ")\n";
				$ranking_tools{$tool}{time_total_divided_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $tools{$tool}{name} . " (" . $ranking_tools{$tool}{time_total_divided} . ")\n";
				$ranking_tools{$tool}{time_total_divided_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_tools{$tool}{time_total_divided};		
		}
		print $fh ("\n\n");

		$pos = 1; $last_value = 0;
		print $fh "\t Energy Ranking:\n";
		for my $tool (sort { $ranking_tools{$a}{energy_total_divided} <=> $ranking_tools{$b}{energy_total_divided} } keys %ranking_tools) {			
			if ($last_value == $ranking_tools{$tool}{energy_total_divided}) {
				print $fh "\t\t  : " . $tools{$tool}{name} . " (" . $ranking_tools{$tool}{energy_total_divided} . ")\n";
				$ranking_tools{$tool}{energy_total_divided_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $tools{$tool}{name}. " (" . $ranking_tools{$tool}{energy_total_divided} . ")\n";
				$ranking_tools{$tool}{energy_total_divided_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_tools{$tool}{energy_total_divided};		
		}
		print $fh ("\n\n");

		$pos = 1; $last_value = 0;
		print $fh "\t CPU Ranking:\n";
		for my $tool (sort { $ranking_tools{$a}{cpu_total_divided} <=> $ranking_tools{$b}{cpu_total_divided} } keys %ranking_tools) {
			if ($last_value == $ranking_tools{$tool}{cpu_total_divided}) {
				print $fh "\t\t  : " . $tools{$tool}{name} . " (" . $ranking_tools{$tool}{cpu_total_divided} . ")\n";
				$ranking_tools{$tool}{cpu_total_divided_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $tools{$tool}{name} . " (" . $ranking_tools{$tool}{cpu_total_divided} . ")\n";
				$ranking_tools{$tool}{cpu_total_divided_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_tools{$tool}{cpu_total_divided};		
		}
		print $fh ("\n\n");

		$pos = 1; $last_value = 0;
		print $fh "\t Memory Ranking:\n";
		for my $tool (sort { $ranking_tools{$a}{memory_total_divided} <=> $ranking_tools{$b}{memory_total_divided} } keys %ranking_tools) {			
			if ($last_value == $ranking_tools{$tool}{memory_total_divided}) {
				print $fh "\t\t  : " . $tools{$tool}{name} . " (" . $ranking_tools{$tool}{memory_total_divided} . ")\n";
				$ranking_tools{$tool}{memory_total_divided_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $tools{$tool}{name} . " (" . $ranking_tools{$tool}{memory_total_divided} . ")\n";
				$ranking_tools{$tool}{memory_total_divided_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_tools{$tool}{memory_total_divided};		
		}
		print $fh ("\n\n");
		
		$pos = 1; $last_value = 0;
		print $fh "\t Energy/Time Ranking:\n";
		for my $tool (sort { $ranking_tools{$a}{joulesec_total_divided} <=> $ranking_tools{$b}{joulesec_total_divided} } keys %ranking_tools) {			
			if ($last_value == $ranking_tools{$tool}{joulesec_total_divided}) {
				print $fh "\t\t  : " . $tools{$tool}{name} . "(" . $ranking_tools{$tool}{joulesec_total_divided} . ")\n";
				$ranking_tools{$tool}{joulesec_total_divided_pos}{$point} = $pos-1;
			}
			else {
				print $fh "\t\t" . $pos .": " . $tools{$tool}{name} . "(" . $ranking_tools{$tool}{joulesec_total_divided} . ")\n";
				$ranking_tools{$tool}{joulesec_total_divided_pos}{$point} = $pos;
				$pos++;
			}
			$last_value = $ranking_tools{$tool}{joulesec_total_divided};		
		}
		print $fh ("\n\n");

		#
		# Total Ranking Table
		#		
		my $table = "";
		my $table_header = "\\thead{\\textbf{Tool Name}} & \\thead{\\textbf{Execution Time \\scriptsize(s)}} & \\thead{\\textbf{Total Energy \\scriptsize(J)}} & \\thead{\\textbf{CPU Energy \\scriptsize(J)}} & \\thead{\\textbf{Memory Energy \\scriptsize(J)}} & \\thead{\\textbf{Energy/Time \\scriptsize(J/s)}}\\\\\\hline";
		for my $tool ( sort {$a <=> $b} keys %ranking_tools) {
			$table = join ("", $table, $tools{$tool}{name} ."\t&\t");
			$table = join ("", $table, $ranking_tools{$tool}{time_total_divided_pos}{$point} . " \\scriptsize(". $ranking_tools{$tool}{time_total_divided} .")". "\t&\t");
			$table = join ("", $table, $ranking_tools{$tool}{energy_total_divided_pos}{$point} . " \\scriptsize(". $ranking_tools{$tool}{energy_total_divided} .")". "\t&\t");
			$table = join ("", $table, $ranking_tools{$tool}{cpu_total_divided_pos}{$point} . " \\scriptsize(". $ranking_tools{$tool}{cpu_total_divided} .")". "\t&\t");
			$table = join ("", $table, $ranking_tools{$tool}{memory_total_divided_pos}{$point} . " \\scriptsize(". $ranking_tools{$tool}{memory_total_divided} .")". "\t&\t");
			$table = join ("", $table, $ranking_tools{$tool}{joulesec_total_divided_pos}{$point} . " \\scriptsize(". $ranking_tools{$tool}{joulesec_total_divided} .")"."\\\\\\hline\n");
		}
		print $fh "\nLaTeX Table\n". $table_header ."\n" . $table ."\n\n"; 
	}
	close $fh;
}


else { print "Option not recognized: " . $argoption ."\n"; }