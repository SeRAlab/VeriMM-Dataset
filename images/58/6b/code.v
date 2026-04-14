module top_module(
    clk,
    shiftnld,
   ldsrc,
    crcerror,
    regout);input clk;
input shiftnld;
input ldsrc;

output crcerror;
output regout;

assign crcerror = 1'b0;
assign regout = 1'b0;

parameter oscillator_divider = 1;
parameter lpm_type = "hardcopyii_crcblock";

endmodule