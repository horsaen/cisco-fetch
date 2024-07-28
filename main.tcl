proc printBanner {} {
  # this could probably be changed to look a little better, will stay for now
  puts "                       @@@                                    @@@                       "
  puts "                       @@@@                                  @@@@                       "
  puts "                       @@@@                                  @@@@                       "
  puts "                       @@@@                                  @@@@                       "
  puts "              @@@      @@@@      @@@                @@@      @@@@      @@@@             "
  puts "             @@@@      @@@@      @@@                @@@      @@@@      @@@@             "
  puts "    @@@      @@@@      @@@@      @@@       @@       @@@      @@@@      @@@@      @@@    "
  puts "    @@@      @@@@      @@@@      @@@      @@@@      @@@      @@@@      @@@@      @@@    "
  puts "    @@@      @@@@      @@@@      @@@      @@@@      @@@      @@@@      @@@@      @@@    "
  puts "    @@@       @@@      @@@@      @@@      @@@@      @@@      @@@@      @@@       @@@    "
  puts "                       @@@@                                  @@@@                       "
  puts "                       @@@                                    @@@                       "
  puts "                                                                                        "
  puts "                                                                                        "
  puts "                                                                                        "
  puts "               @@@@@@@     @@@       @@@@@@         @@@@@@        @@@@@@@               "
  puts "             @@@@@@@@@     @@@     @@@@@@@@      @@@@@@@@@      @@@@@@@@@@@             "
  puts "            @@@@           @@@     @@@@         @@@@@          @@@@     @@@@            "
  puts "           @@@@            @@@     @@@@@@@@     @@@@          @@@@       @@@@           "
  puts "           @@@@            @@@        @@@@@@    @@@@          @@@@       @@@@           "
  puts "            @@@@           @@@           @@@    @@@@@          @@@@     @@@@            "
  puts "             @@@@@@@@@     @@@     @@@@@@@@@     @@@@@@@@@      @@@@@@@@@@@             "
  puts "               @@@@@@@     @@@     @@@@@@@          @@@@@@        @@@@@@@               "
  puts "                                                                                        "
  puts "________________________________________________________________________________________\n"
}

proc getModelNumber {} {
  # show version
  set command "sh ve | i Model number"

  set inputString [exec $command]

  regsub {Model number\s*:\s*} $inputString "" model

  return "Device: $model"
}

proc getUptime {} {
  # show version
  set command "sh ve | i Switch uptime"

  set inputString [exec $command]

  regsub {Switch uptime is\s*\s*} $inputString "" uptime

  return "Uptime: $uptime"
}

proc getTemperature {} {
  # show env temperature status
  set command "sh env te s | i System Temperature Value"

  set inputString [exec $command]

  regsub {System Temperature Value\s*:\s*} $inputString "" temperature

  return "Temperature: $temperature"
}

proc convBytes {bytes} {

    set units [list "bytes" "KB" "MB" "GB" "TB"]
    set unit_values [list 1 1024 1048576 1073741824 1099511627776]

    set index 0
    while {$index < [llength $unit_values] && $bytes >= [lindex $unit_values $index] * 1024} {
        incr index
    }

    set value [expr {$bytes / [lindex $unit_values $index]}]
    
    set formatted_value [format "%.2f" $value]

    return "${formatted_value} [lindex $units $index]"
}

proc getSpace {} {
  # show flash
  set command "sh fl | i bytes total"

  set inputString [exec $command]

  regexp {(\d+) bytes total} $inputString -> totalBytes
  regexp {\((\d+) bytes free\)} $inputString -> freeBytes

  set used [convBytes [expr $totalBytes - $freeBytes]]
  set total [convBytes $totalBytes]

  return "Storage: $used / $total\n"
}

proc countLines {text} {
    # Split the text into lines
    set lines [split $text "\n"]
    # Return the number of lines
    return [llength $lines]
}

proc getInterfaces {} {
  set totalCommand "sh ve | i Gigabit Ethernet"
  set upCommand "sh int | i (connected)"

  regexp {(\d+) Gigabit Ethernet interfaces} [exec $totalCommand] -> totalIfaces

  set upIfaces [expr [countLines [exec $upCommand]] - 1 ]

  return "Ethernet: $upIfaces / $totalIfaces"
}

proc main {} {
  printBanner
  puts [getModelNumber]
  puts [getUptime]
  puts [getTemperature]
  puts [getSpace]
  puts [getInterfaces]
}

main