module top_module(input [3:0] d, input en, output reg [3:0] q);always @*
  if (en)
    q <= d;
endmodule