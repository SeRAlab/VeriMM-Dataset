module top_module(input wire plus1,input wire [2:0] color_in,output reg [1:0] color_out);always @* 
  case( color_in ) 
  3'b000: color_out <= 2'b00; 
  3'b001: color_out <= plus1 ? 2'b01 : 2'b00; 
  3'b010: color_out <= 2'b01; 
  3'b011: color_out <= plus1 ? 2'b10 : 2'b01; 
  3'b100: color_out <= 2'b10; 
  3'b101: color_out <= plus1 ? 2'b11 : 2'b10; 
  default: color_out <= 2'b11; 
  endcase 
 endmodule