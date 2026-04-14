module top_module(
  In0,
  In1,
  dout
);input wire [0 : 0] In0;
input wire [0 : 0] In1;
output wire [1 : 0] dout;

assign dout[0] = In0;
assign dout[1] = In1;

endmodule