module top_module(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);input clk;
input we3;
input [4:0] ra1;
input [4:0] ra2;
input [4:0] wa3;
input [31:0] wd3;
output [31:0] rd1;
output [31:0] rd2;

reg [31:0] BANK_REG_FILE[31:0];

always @ (posedge clk)
if (we3)
    BANK_REG_FILE[wa3] <= wd3;
assign rd1 = (ra1 != 0) ? BANK_REG_FILE[ra1] : 0;
assign rd2 = (ra2 != 0) ? BANK_REG_FILE[ra2] : 0;

endmodule