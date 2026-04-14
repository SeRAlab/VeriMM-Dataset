module top_module(input [3:0] mod0, output reg [6:0] led);always @(*) begin 
  case(mod0) 
  4'd0 : led = 7'b100_0000; 
  4'd1 : led = 7'b111_1001; 
  4'd2 : led = 7'b010_0100; 
  4'd3 : led = 7'b011_0000; 
  4'd4 : led = 7'b001_1001; 
  4'd5 : led = 7'b001_0010; 
  4'd6 : led = 7'b000_0010; 
  4'd7 : led = 7'b111_1000; 
  4'd8 : led = 7'b000_0000; 
  4'd9 : led = 7'b001_0000; 
  default : led = 7'b111_1111; 
  endcase 
 end 
endmodule