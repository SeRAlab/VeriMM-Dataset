module top_module(A, B, C);input [3:0] A, B;
output [3:0] C;

wire [3:0] and_result;
wire [3:0] or_result;

assign and_result = A & B;
assign or_result = and_result | 4'b1010;

assign C = or_result;

endmodule