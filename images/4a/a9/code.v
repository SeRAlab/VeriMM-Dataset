module top_module(
    clk,
    shiftnld,
    crcerror,
    regout);input clk;
input shiftnld;

output crcerror;
output regout;

assign crcerror = 1'b0;
assign regout = 1'b0;

parameter oscillator_divider = 1;
parameter lpm_type = "maxv_crcblock";

endmodule