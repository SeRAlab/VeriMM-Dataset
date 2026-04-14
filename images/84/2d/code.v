module top_module(clk, Digit,Display);input clk; 
  input [3:0] Digit; 
  output reg [7:0] Display; 
  always @ (posedge clk) begin 
  case (Digit) 
  4'h0: Display = 8'b11000000; 
  4'h1: Display = 8'b11111001; 
  4'h2: Display = 8'b10100100; 
  4'h3: Display = 8'b10110000; 
  4'h4: Display = 8'b10011001; 
  4'h5: Display = 8'b10010010; 
  4'h6: Display = 8'b10000010; 
  4'h7: Display = 8'b11111000; 
  4'h8: Display = 8'b10000000; 
  4'h9: Display = 8'b10010000; 
  default: Display = 8'b11111111; 
  endcase 
  end 
 endmodule