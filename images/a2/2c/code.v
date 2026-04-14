module top_module(A1, A2, A3, Z);input A1, A2, A3;
output Z;
assign Z = ~(A1 & A2 & A3);endmodule