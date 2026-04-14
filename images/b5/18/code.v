module top_module(sel, in0, in1, in2, in3, out);input  [1:0]  sel;
  input  in0, in1, in2, in3;
  output out;

  reg    out;

  always @(sel or in0 or in1 or in2 or in3)
    case(sel)
     2'd0:  out = in0;
     2'd1:  out = in1;
     2'd2:  out = in2;
     2'd3:  out = in3;
    endcase
endmodule