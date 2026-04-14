module top_module(A,B,Z,S);input A,B,S;
output Z;
assign Z = S ? B: A;
endmodule