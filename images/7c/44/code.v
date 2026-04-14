module top_module(A,B,C,D,f);input A,B,C,D;
output f;
wand f;



assign f=A&B;
assign f=C|D;

endmodule