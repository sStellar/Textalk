# RUBY

br = File.read("/sys/class/backlight/acpi_video0/brightness").to_i

case ARGV[0]
when "-"
  br = File.read("/sys/class/backlight/acpi_video0/brightness").to_i
  if br > 9
    br = (br - 10).to_s
  end
when "+"
  if br < 91
    br = (br + 10).to_s
  end
else

end

IO.popen("echo #{br} > /sys/class/backlight/acpi_video0/brightness")
