module top_module(a,b,cin,out,cout,op);input [7:0] a;
input [7:0] b;
input cin;
output [7:0] out;
output cout;
input op; 

assign {cout, out} = (op==0) ? (a + b + cin) : (a - b - cin);endmodule