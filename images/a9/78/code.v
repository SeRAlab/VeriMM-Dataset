module top_module(input[1:0] rot, output reg[0:15] block);wire[0:15] o0 = 16'b1100110000000000; 
 always @* 
 begin 
  case(rot) 
  default: block = o0; 
  endcase 
 end 
 endmodule