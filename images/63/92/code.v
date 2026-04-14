module top_module(in1, wenable, clock, reset, out1);parameter BITSIZE_in1=32, BITSIZE_out1=32;
  
  input [BITSIZE_in1-1:0] in1;
  input wenable;
  input clock;
  input reset;
  
  output [BITSIZE_out1-1:0] out1;
  reg [BITSIZE_out1-1:0] reg_out1;
  assign out1 = reg_out1;
  always @(posedge clock or posedge reset)
    if (reset)
      reg_out1 <= {BITSIZE_out1{1'b0}};
    else if (wenable)
      reg_out1 <= in1;endmodule