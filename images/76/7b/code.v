module top_module(inValue, display);input [3:0] inValue; 
  output [6:0] display; 
  reg [6:0] display; 
  always @(*) begin 
  case(inValue) 
  4'b0000: display = 7'b1000000; 
  4'b0001: display = 7'b1111001; 
  4'b0010: display = 7'b0100100; 
  4'b0011: display = 7'b0110000; 
  4'b0100: display = 7'b0011001; 
  4'b0101: display = 7'b0010010; 
  4'b0110: display = 7'b0000010; 
  4'b0111: display = 7'b1111000; 
  4'b1000: display = 7'b0000000; 
  4'b1001: display = 7'b0011000; 
  4'b1010: display = 7'b0001000; 
  4'b1011: display = 7'b0000011; 
  4'b1100: display = 7'b1000110; 
  4'b1101: display = 7'b0100001; 
  4'b1110: display = 7'b0000110; 
  4'b1111: display = 7'b0001110; 
  endcase 
  end 
 endmodule