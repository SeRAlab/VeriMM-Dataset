module top_module(A1, A2, A3, A4, Z);input A1, A2, A3, A4;
output Z;
assign Z = ~(A1 & A2 & A3 & A4);endmodule