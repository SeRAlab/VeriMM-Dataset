module top_module(in, inant, count1);input [7:0] in;
  input [7:0] inant;
  output reg count1;

  always @(in)
    if(in == inant) count1 <= 1;
    else count1 <= 0;

endmodule