set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Yellow
$ns color 5 Purple

set nf [open drop-tail.nam w]
$ns namtrace-all $nf
set tf [open drop-tail.tr w]
$ns trace-all $tf
set f0 [open dt0.tr w]
set f1 [open dt1.tr w]
set f2 [open dt2.tr w]
set f3 [open dt3.tr w]
set f4 [open dt4.tr w]
set in [open throughput.awk r]

proc finish {} {
        global ns nf tf f0 f1 f2 f3 f4 in
        $ns flush-trace
        close $nf
        close $tf
        close $f0
        close $f1
        close $f2
        close $f3
        close $f4
        close $in
        exec awk -f throughput.awk drop-tail.tr &
        exec nam drop-tail.nam &
        exec xgraph dt0.tr dt1.tr dt2.tr dt3.tr dt4.tr &
        exit 0
}

proc record {} {
        global sink0 sink1 sink2 sink3 sink4 f0 f1 f2 f3 f4
        #Get an instance of the simulator
        set ns [Simulator instance]
        #Set the time after which the procedure should be called again
        set time 0.5
        #How many bytes have been received by the traffic sinks?
        set bw0 [$sink0 set bytes_]
        set bw1 [$sink1 set bytes_]
        set bw2 [$sink2 set bytes_]
        set bw3 [$sink3 set bytes_]
        set bw4 [$sink4 set bytes_]
        #Get the current time
        set now [$ns now]
        #Calculate the bandwidth (in MBit/s) and write it to the files
        puts $f0 "$now [expr $bw0/$time*8/1000000]"
        puts $f1 "$now [expr $bw1/$time*8/1000000]"
        puts $f2 "$now [expr $bw2/$time*8/1000000]"
        puts $f3 "$now [expr $bw3/$time*8/1000000]"
        puts $f4 "$now [expr $bw4/$time*8/1000000]"
        #Reset the bytes_ values on the traffic sinks
        $sink0 set bytes_ 0
        $sink1 set bytes_ 0
        $sink2 set bytes_ 0
        $sink3 set bytes_ 0
        $sink4 set bytes_ 0
        #Re-schedule the procedure
        $ns at [expr $now+$time] "record"
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]

$ns duplex-link $n0 $n5 5Mb 20ms DropTail
$ns duplex-link $n5 $n6 0.5Mb 100ms DropTail
$ns duplex-link $n1 $n6 5Mb 20ms DropTail
$ns duplex-link $n6 $n7 0.5Mb 100ms DropTail
$ns duplex-link $n2 $n7 5Mb 20ms DropTail
$ns duplex-link $n7 $n8 0.5Mb 100ms DropTail
$ns duplex-link $n3 $n8 5Mb 20ms DropTail
$ns duplex-link $n8 $n9 0.5Mb 100ms DropTail
$ns duplex-link $n4 $n9 5Mb 20ms DropTail
$ns duplex-link $n9 $n10 0.5Mb 100ms DropTail

$ns duplex-link-op $n0 $n5 orient down
$ns duplex-link-op $n5 $n6 orient right
$ns duplex-link-op $n1 $n6 orient down
$ns duplex-link-op $n6 $n7 orient right
$ns duplex-link-op $n2 $n7 orient down
$ns duplex-link-op $n7 $n8 orient right
$ns duplex-link-op $n3 $n8 orient down
$ns duplex-link-op $n8 $n9 orient right
$ns duplex-link-op $n4 $n9 orient down
$ns duplex-link-op $n9 $n10 orient right

$ns duplex-link-op $n5 $n6 queuePos 0.5
$ns duplex-link-op $n6 $n7 queuePos 0.5
$ns duplex-link-op $n7 $n8 queuePos 0.5
$ns duplex-link-op $n8 $n9 queuePos 0.5
$ns duplex-link-op $n9 $n10 queuePos 0.5

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP
set sink0 [new Agent/TCPSink]
$ns attach-agent $n10 $sink0
$ns connect $tcp0 $sink0
$tcp0 set fid_ 1

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP
set sink1 [new Agent/TCPSink]
$ns attach-agent $n10 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP
set sink2 [new Agent/TCPSink]
$ns attach-agent $n10 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 3

set tcp3 [new Agent/TCP]
$ns attach-agent $n3 $tcp3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ftp3 set type_ FTP
set sink3 [new Agent/TCPSink]
$ns attach-agent $n10 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 4

set tcp4 [new Agent/TCP]
$ns attach-agent $n4 $tcp4
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ftp4 set type_ FTP
set sink4 [new Agent/TCPSink]
$ns attach-agent $n10 $sink4
$ns connect $tcp4 $sink4
$tcp4 set fid_ 5

$ns at 0.0 "record"

$ns at 0.1 "$ftp0 start"
$ns at 0.1 "$ftp1 start"
$ns at 0.1 "$ftp2 start"
$ns at 0.1 "$ftp3 start"
$ns at 0.1 "$ftp4 start"
$ns at 10.0 "$ftp0 stop"
$ns at 10.0 "$ftp1 stop"
$ns at 10.0 "$ftp2 stop"
$ns at 10.0 "$ftp3 stop"
$ns at 10.0 "$ftp4 stop"

$ns at 10.5 "finish"

$ns run

