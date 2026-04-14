module top_module(a,b,cin,sum,carryout);input cin;
input a;
input b;
output sum;
output carryout;

assign axorb    = a ^ b;
assign sum      = cin ^ axorb;
assign carryout = (a & b) | (axorb & cin);

endmodule