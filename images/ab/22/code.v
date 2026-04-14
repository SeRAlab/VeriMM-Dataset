module top_module(sel, in0, in1, out);input        sel;
  input  [7:0] in0, in1;
  output [7:0] out;

  reg    [7:0] out;

  always @(sel or in0 or in1)
    case(sel)
     1'd0:  out = in0;
     1'd1:  out = in1;
    endcase
endmodule