module top_module(A, B, clk, Z);input [3:0] A, B;
input clk;
output reg [3:0] Z;

always @(posedge clk) begin
    Z <= A + B;
end

endmodule