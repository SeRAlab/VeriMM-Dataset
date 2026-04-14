module top_module(input wire[2:0] iIn,output reg [7:0] oOut);always @ ( * ) 
 begin 
  case (iIn) 
  3'b000: oOut = 8'b00000001; 
  3'b001: oOut = 8'b00000010; 
  3'b010: oOut = 8'b00000100; 
  3'b011: oOut = 8'b00001000; 
  3'b100: oOut = 8'b00010000; 
  3'b101: oOut = 8'b00100000; 
  3'b110: oOut = 8'b01000000; 
  3'b111: oOut = 8'b10000000; 
  default: oOut = 8'b0; 
  endcase 
 end 
 endmodule