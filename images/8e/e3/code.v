module top_module(
    input clk,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg out_valid
);always @(posedge clk) begin
        out <= a & b;
        out_valid <= 1'b1;
    end
    
endmodule