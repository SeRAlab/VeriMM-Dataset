module top_module(input[1:0] rot, output reg[0:15] block);wire[0:15] i0 = 16'b1000100010001000; 
 wire[0:15] i1 = 16'b0000000011110000; 
 always @* 
 begin 
  case(rot) 
  0: block = i0; 
  1: block = i1; 
  2: block = i0; 
  3: block = i1; 
  default: block = i0; 
  endcase 
 end 
 endmodule