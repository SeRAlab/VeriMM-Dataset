module top_module(A,B,Z,CO);input A,B;
output Z,CO;
assign {CO,Z}=A+B;
endmodule