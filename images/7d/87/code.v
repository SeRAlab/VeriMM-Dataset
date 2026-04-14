module top_module(
input          din,           		
output         dout_p,           	
output         dout_n           	
);`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  

assign #(2 * INV_DELAY) dout_p = din;
assign #(2 * INV_DELAY) dout_n = ~din;

endmodule