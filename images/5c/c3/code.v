module top_module(input [4:0] i,output reg [7:0] o);always @(i) 
  case (i) 
  5'h00: o <= 8'h68; 
  5'h01: o <= 8'h77; 
  5'h02: o <= 8'h5f; 
  5'h03: o <= 8'h64; 
  5'h04: o <= 8'h62; 
  5'h05: o <= 8'h67; 
  5'h06: o <= 8'h20; 
  5'h07: o <= 8'h5b; 
  5'h08: o <= 8'h43; 
  5'h09: o <= 8'h44; 
  5'h0a: o <= 8'h57; 
  5'h0b: o <= 8'h42; 
  5'h0c: o <= 8'h5d; 
  5'h0d: o <= 8'h20; 
  5'h0f: o <= 8'h78; 
  default: o <= 8'h30; 
  endcase 
 endmodule