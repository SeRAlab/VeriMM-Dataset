module top_module(out,in0,in1,select);output [29:0] out ; 
  input [29:0] in0, in1 ; 
  input select ; 
  reg [29:0] out ; 
  always @ (select or in0 or in1) 
  case (select) 
  1'b0: out = in0; 
  1'b1: out = in1; 
  default: out = 65'hx; 
  endcase 
 endmodule