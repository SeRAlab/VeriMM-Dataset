module top_module(nybble, digit);input [3:0] nybble; 
  output reg [7:0] digit; 
  always @(*) begin 
  case(nybble) 
  0: 
  digit <= 8'h30; 
  1: 
  digit <= 8'h31; 
  2: 
  digit <= 8'h32; 
  3: 
  digit <= 8'h33; 
  4: 
  digit <= 8'h34; 
  5: 
  digit <= 8'h35; 
  6: 
  digit <= 8'h36; 
  7: 
  digit <= 8'h37; 
  8: 
  digit <= 8'h38; 
  9: 
  digit <= 8'h39; 
  10: 
  digit <= 8'h41; 
  11: 
  digit <= 8'h42; 
  12: 
  digit <= 8'h43; 
  13: 
  digit <= 8'h44; 
  14: 
  digit <= 8'h45; 
  15: 
  digit <= 8'h46; 
  default: 
  digit <= 8'bxxxxxxxx; 
  endcase 
  end 
 endmodule