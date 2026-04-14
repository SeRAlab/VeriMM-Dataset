module top_module(A, B, S, Z);input A, B, S;
output Z;

wire temp;

assign temp = (S == 0) ? A : B;
assign Z = temp;

endmodule