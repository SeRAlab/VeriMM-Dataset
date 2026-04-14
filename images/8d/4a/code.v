module top_module(input [63:0]  data_in,
 input         ctl_in,

output [63:0] data_out,
output        ctl_out);assign data_out  = data_in[1] ? data_in[63:0]
:            64'h0;

endmodule