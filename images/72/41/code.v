module top_module(input clk, input enable, input [3:0] val, input [2:0] sidx, output reg[7:0] digit, output reg[7:0] segment);always @(posedge clk) 
 begin 
  if (enable) 
  begin 
  case (sidx) 
  3'd0: begin digit <= 8'b11111110; end 
  3'd1: begin digit <= 8'b11111101; end 
  3'd2: begin digit <= 8'b11111011; end 
  3'd3: begin digit <= 8'b11110111; end 
  3'd4: begin digit <= 8'b11101111; end 
  3'd5: begin digit <= 8'b11011111; end 
  3'd6: begin digit <= 8'b10111111; end 
  3'd7: begin digit <= 8'b01111111; end 
  default: begin digit <= 8'b11111111; end 
  endcase 
  case (val) 
  3'b000: begin segment <= 8'b00000011; end 
  3'b001: begin segment <= 8'b10011111; end 
  3'b010: begin segment <= 8'b00100101; end 
  3'b011: begin segment <= 8'b00001101; end 
  3'b100: begin segment <= 8'b10011001; end 
  3'b101: begin segment <= 8'b01001001; end 
  3'b110: begin segment <= 8'b01000001; end 
  3'b111: begin segment <= 8'b00011111; end 
  4'b1000: begin segment <= 8'b00000001; end 
  4'b1001: begin segment <= 8'b00001001; end 
  default: begin segment <= 8'b11111111; end 
  endcase 
  end 
 end 
 endmodule