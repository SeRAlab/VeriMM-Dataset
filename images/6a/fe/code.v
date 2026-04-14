module top_module(A,B,Z,CI,CO);input A,B,CI;
output Z,CO;
assign {CO,Z}=A+B+CI;
endmodule