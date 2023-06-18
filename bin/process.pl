#!/usr/local/bin/perl
$m1 = 0.8;
$m2 = 1.1;
$s1 = 10.0;
$s2 = 1.0;
$rho = 5e+7;
$pi = atan2(1,1) * 4;
$solmass = 1.99e+33;
$ye = 0.45;

for ($i=0; $i<10; $i++) {
$_=<STDIN>;
print;
}
while(<STDIN>) {
@nums = split;
$mass = $nums[1];
if ($mass < $m1) {$nums[9] = $s1;}
elsif ($mass > $m2) {$nums[9] = $s2;}
else {$nums[9] = ($mass-$m1) / ($m2-m1) * ($s2-$s1) + $s1;};
$radius = ($mass * $solmass / $rho / 4 / $pi * 3) ** (1/3);
print sprintf("%4d%12g%12g%12g%12g%12g%12g%12g%12g%12g%12g\n",@nums[0..2],$radius, $rho,0,$ye,0,0,$nums[9]);
}
