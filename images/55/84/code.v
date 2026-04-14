module top_module(
  din0, 
  sel0, 
  din1, 
  sel1, 
  dout);input [5:0] din0;
  input sel0;
  input [5:0] din1;
  input sel1;
  output [5:0] dout;





assign dout[5:0] = ( {6{sel0}} & din0[5:0] ) |
                       ( {6{sel1}} & din1[5:0]);endmodule