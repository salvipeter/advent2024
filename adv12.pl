my $height = scalar @data;
my $width = length $data[0];

my $size = $height * $width;
my @groups = (0) x $size;
my $count = 0;

for my $i (0..$size-1) {
    if ($groups[$i] == 0) {
        $count++;
        &flood(int($i / $width), $i % $width, $count);
    }
}

my (@area, @perimeter) = ((0) x ($count + 1), (0) x ($count + 1));
for my $i (0..$size-1) {
    my $plot = $groups[$i];
    $area[$plot]++;
    $perimeter[$plot] += $ARGV[0] == 1 ? &fence($i) : &bulk($i);
}

sub flood {
    my ($i, $j, $g) = @_;
    my $index = $i * $width + $j;
    if ($groups[$index] != 0) {
        return
    }
    $groups[$index] = $g;
    my $p = substr($data[$i], $j, 1);
    flood($i - 1, $j, $g) if ($i > 0           && substr($data[$i-1], $j,     1) eq $p);
    flood($i + 1, $j, $g) if ($i < $height - 1 && substr($data[$i+1], $j,     1) eq $p);
    flood($i, $j - 1, $g) if ($j > 0           && substr($data[$i],   $j - 1, 1) eq $p);
    flood($i, $j + 1, $g) if ($j < $width - 1  && substr($data[$i],   $j + 1, 1) eq $p);
}

sub fence {
    my $index = shift;
    my ($i, $j) = (int($index / $width), $index % $width);
    my $g = $groups[$index];
    my $count = 0;
    $count++ if ($i == 0           || $groups[$index-$width] != $g);
    $count++ if ($i == $height - 1 || $groups[$index+$width] != $g);
    $count++ if ($j == 0           || $groups[$index-1]      != $g);
    $count++ if ($j == $width - 1  || $groups[$index+1]      != $g);
    return $count
}

my %counted;

sub bulk {
    my $index = shift;
    my ($i, $j) = (int($index / $width), $index % $width);
    my $g = $groups[$index];
    my $count = 0;
    $count += &mark($g, $i == 0,           $index, -$width, 1,      "U");
    $count += &mark($g, $i == $height - 1, $index,  $width, 1,      "D");
    $count += &mark($g, $j == 0,           $index, -1,      $width, "L");
    $count += &mark($g, $j == $width  - 1, $index,  1,      $width, "R");
    return $count
}

sub mark {
    my ($g, $pred, $i, $j, $k, $c) = @_;
    $j = $i + $j;               # index of adjacent cell
    $k = $i - $k;               # index of probable previous cell with the same fence
    if ($pred || $groups[$j] != $g) {
        $counted{"$i,$c"} = 1;
        return !exists $counted{"$k,$c"} || $groups[$k] != $g
    }
    return 0
}

my $sum = 0;
for (1..$count) {
    $sum += $area[$_] * $perimeter[$_];
}
print $sum, "\n";
