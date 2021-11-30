#!/usr/bin/env raku

#use Grammar::Debugger;
use Grammar::Tracer;
use Data::Dump::Tree;

my $datetime    = "Tue Nov 30 08:58:16 EST 2021\n2021-11-30 09:58:18.543592-05:00";

grammar System-Clock-Hardware-Clock-Timestamps {
    token TOP {
        ^
        <system-clock-timestamp>
        \n
        <hardware-clock-timestamp>
        $
    }
    token system-clock-timestamp {
        <day-of-week>   \s+
        <alpha-month>   \s+
        <day-of-month>  \s+
        <hms>           \s+
        <time-zone>     \s+
        <year>
    }
    token hardware-clock-timestamp {
        <year>          '-'
        <numeric-month> '-'
        <day-of-month>  \s+
        <hms>           '.'
        <subseconds>    '-'
        <zone-offset>
    }
    token day-of-week   { 'Sun' || 'Mon' || 'Tue' || 'Wed' || 'Thu' || 'Fri' || 'Sat' }
    token alpha-month   { 'Jan' || 'Feb' || 'Mar' || 'Apr' || 'May' || 'Jun' || 'Jul' || 'Aug' || 'Sep' || 'Oct' || 'Nov' || 'Dec' }
    token numeric-month { \d\d }
    token day-of-month  { \d\d }
    token hms           { <hours> ':' <minutes> ':' <seconds> }
    token hours         { \d\d }
    token minutes       { \d\d }
    token seconds       { \d\d }
    token subseconds    { \d+ }
    token time-zone     { \w\w\w }
    token zone-offset   { <hours> ':' <minutes> }
    token year          { \d\d\d\d }
}

class System-Clock-Hardware-Clock-Timestamps-Actions {
    method system-clock-timestamp ($/) {
        make DateTime.new(
            year    => ~$/<year>,
            month   => ~$/<alpha-month>.made,
            day     => ~$/<day-of-month>,
            hour    => ~$/<hms><hours>,
            minute  => ~$/<hms><minutes>,
            second  => ~$/<hms><seconds>,
        );
    }
    method alpha-month ($/) {
        my %a2n = ( Jan => 0, Feb => 1, Mar => 2, Apr => 3, May => 4, Jun => 5, Jul => 6, Aug => 7, Sep => 8, Oct => 9, Nov => 10, Dec => 11 );
        make %a2n{~$/};
    }
}

#ddt System-Clock-Hardware-Clock-Timestamps.parse($datetime);
#ddt System-Clock-Hardware-Clock-Timestamps.parse($datetime, :actions(System-Clock-Hardware-Clock-Timestamps-Actions.new));
my $match-tree = System-Clock-Hardware-Clock-Timestamps.parse($datetime, :actions(System-Clock-Hardware-Clock-Timestamps-Actions.new));
put $match-tree<system-clock-timestamp>.made.Str;

