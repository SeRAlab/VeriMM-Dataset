module top_module(
 input x,
 input y,
 input cin,

 output reg A,
 output cout
 );parameter WIDTH = 1;
 wire o;

`ifndef BUG



assign cout =  cin ? y : x;


`else
assign {cout,A} =  cin - y * x;
`endif

endmodule