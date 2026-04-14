module top_module(a_in , s_out);input [3:0] a_in; 
  output [7:0] s_out; 
  reg [7:0] temp; 
  assign s_out = temp; 
  always @(a_in) begin 
  case (a_in) 
  4'b0000: temp = 8'b00111111; 
  4'b0001: temp = 8'b00000110; 
  4'b0010: temp = 8'b01011011; 
  4'b0011: temp = 8'b01001111; 
  4'b0100: temp = 8'b01100110; 
  4'b0101: temp = 8'b01101101; 
  4'b0110: temp = 8'b01111101; 
  4'b0111: temp = 8'b00100111; 
  4'b1000: temp = 8'b01111111; 
  4'b1001: temp = 8'b01101111; 
  default: temp = 8'b00000000; 
  endcase 
  end 
 endmodule