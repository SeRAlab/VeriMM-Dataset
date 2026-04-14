module top_module(
    input [7:0] a,
    input [7:0] b,
    input clk,
    output reg [7:0] result
);always @(posedge clk) begin
        // Perform bitwise AND operation on inputs
        result <= a & b;
    end

endmodule