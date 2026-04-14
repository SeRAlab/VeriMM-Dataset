module top_module(input wire[3:0] in_val, output reg[3:0] out_val);always @(in_val) begin 
  case (in_val) 
  4'b0101: out_val <= 4'b1000; 
  4'b0110: out_val <= 4'b1001; 
  4'b0111: out_val <= 4'b1010; 
  4'b1000: out_val <= 4'b1011; 
  4'b1001: out_val <= 4'b1100; 
  4'b1010: out_val <= 4'b1101; 
  4'b1011: out_val <= 4'b1110; 
  4'b1100: out_val <= 4'b1111; 
  default: out_val <= in_val; 
  endcase 
 end 
 endmodule