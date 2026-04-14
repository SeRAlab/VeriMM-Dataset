module top_module(Out, In);output [7:0]Out; 
  reg [7:0]Out; 
  input [2:0] In; 
  always @ (In) 
  case (In) 
  3'b000: Out=8'b00000001; 
  3'b001: Out=8'b00000010; 
  3'b010: Out=8'b00000100; 
  3'b011: Out=8'b00001000; 
  3'b100: Out=8'b00010000; 
  3'b101: Out=8'b00100000; 
  3'b110: Out=8'b01000000; 
  3'b111: Out=8'b10000000; 
  endcase 
 endmodule