module top_module(
    input clk, mR, mW,
    input [15:0] address, WD,
    output reg [15:0] RD
    );always @ (clk)
        begin
            RD = WD;
        end
endmodule