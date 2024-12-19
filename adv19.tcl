set cache [dict create]
proc possible str {
    global cache data towels
    if {[dict exists $cache $str]} {
        return [dict get $cache $str]
    }
    set count 0
    foreach t $towels {
        set l [string length $t]
        if {[string equal -length $l $str $t]} {
            if {[string length $str] == $l} {
                incr count 1
            } else {
                incr count [possible [string range $str $l end]]
            }
        }
    }
    dict set cache $str $count
    return $count
}

set count 0
set sum 0
foreach design $data {
    set p [possible $design]
    incr count [expr {$p ? 1 : 0}]
    incr sum $p
}
puts $count
puts $sum
