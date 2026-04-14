module top_module(
	rst_n,
	clk_6hz,
	jtag_sel,
	iic_sel,
	scl,
	lm80_reset_n,
	led_test0,
	jtag_con,
	jtag_sys,
	scl0,
	scl1,
	scl2,
	scl3,
	scl4,
	scl5,
	scl6,
	scl7
);input rst_n;
input clk_6hz;
input jtag_sel;
input [7:0] iic_sel;
input scl;
output lm80_reset_n;
output led_test0;
output jtag_con;
output jtag_sys;
output scl0;
output scl1;
output scl2;
output scl3;
output scl4;
output scl5;
output scl6;
output scl7;
assign  lm80_reset_n = rst_n;
assign  led_test0 = clk_6hz;
assign  jtag_con = jtag_sel;
assign  jtag_sys = ~jtag_sel;
assign  scl0 = (iic_sel == 8'h00)?scl:1'bz;
assign  scl1 = (iic_sel == 8'h01)?scl:1'bz;
assign  scl2 = (iic_sel == 8'h02)?scl:1'bz;
assign  scl3 = (iic_sel == 8'h03)?scl:1'bz;
assign  scl4 = (iic_sel == 8'h04)?scl:1'bz;
assign  scl5 = (iic_sel == 8'h05)?scl:1'bz;
assign  scl6 = (iic_sel == 8'h06)?scl:1'bz;
assign  scl7 = (iic_sel == 8'h07)?scl:1'bz;
endmodule