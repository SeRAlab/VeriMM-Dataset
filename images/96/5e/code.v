module top_module(A,B,Z,s);input A,B;
input s;
output Z;
assign Z=(s==0)?A:B;
endmodule