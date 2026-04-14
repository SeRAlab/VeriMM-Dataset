module top_module(
    input [7:0] A,
    input [7:0] B,
    input clk,
    output reg [7:0] X
);always @(posedge clk) begin
        X <= A ^ B;
    end

endmodule