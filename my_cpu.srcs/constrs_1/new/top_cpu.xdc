## 时钟
set_property PACKAGE_PIN Y8 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk]
create_clock -period 100000 -name sys_clk [get_ports clk]

## 复位按键
set_property PACKAGE_PIN N18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

#输出led
set_property PACKAGE_PIN C15 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]

set_property PACKAGE_PIN E15 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]

set_property PACKAGE_PIN B16 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]

set_property PACKAGE_PIN A16 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]

set_property PACKAGE_PIN G15 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

set_property PACKAGE_PIN F16 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN C18 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN D16 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

## 七段数码管段选（共阳极）
set_property PACKAGE_PIN K19 [get_ports {seg[0]}]
set_property PACKAGE_PIN P16 [get_ports {seg[7]}] 
set_property PACKAGE_PIN P17 [get_ports {seg[6]}]
set_property PACKAGE_PIN N17 [get_ports {seg[5]}]
set_property PACKAGE_PIN N15 [get_ports {seg[4]}]
set_property PACKAGE_PIN M15 [get_ports {seg[3]}]
set_property PACKAGE_PIN L17 [get_ports {seg[2]}]
set_property PACKAGE_PIN L18 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## 数码管位选（4个数码管，需要3位片选信号）
set_property PACKAGE_PIN L22 [get_ports {sel[0]}]
set_property PACKAGE_PIN P21 [get_ports {sel[1]}]
set_property PACKAGE_PIN N20 [get_ports {sel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[*]}]