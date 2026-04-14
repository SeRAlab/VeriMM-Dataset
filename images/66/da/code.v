module top_module(dout, in0, in1, in2, in3,sel0_l, sel1_l, sel2_l, sel3_l);parameter SIZE = 1; 
 output [SIZE-1:0] dout; 
 input [SIZE-1:0] in0; 
 input [SIZE-1:0] in1; 
 input [SIZE-1:0] in2; 
 input [SIZE-1:0] in3; 
 input sel0_l; 
 input sel1_l; 
 input sel2_l; 
 input sel3_l; 
 reg [SIZE-1:0] dout ; 
 `ifdef VERPLEX 
  $constraint dl_1c_chk4 ($one_cold ({sel3_l,sel2_l,sel1_l,sel0_l})); 
 `endif 
 wire [3:0] sel = {sel3_l,sel2_l,sel1_l,sel0_l}; 
 always @ (sel0_l or sel1_l or sel2_l or sel3_l or in0 or in1 or in2 or in3) 
  case ({sel3_l,sel2_l,sel1_l,sel0_l}) 
  4'b1110 : dout = in0 ; 
  4'b1101 : dout = in1 ; 
  4'b1011 : dout = in2 ; 
  4'b0111 : dout = in3 ; 
  4'b1111 : dout = {SIZE{1'bx}} ; 
  default : dout = {SIZE{1'bx}} ; 
  endcase 
 endmodule