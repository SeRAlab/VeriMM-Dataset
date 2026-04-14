module top_module(input [7:0] OPCODE,output reg [8:0] DECODED);always @(OPCODE) 
  case(OPCODE) 
  8'h3E: DECODED <= 9'b0_0000_0001; 
  8'h3C: DECODED <= 9'b0_0000_0010; 
  8'h2B: DECODED <= 9'b0_0000_0100; 
  8'h2D: DECODED <= 9'b0_0000_1000; 
  8'h2E: DECODED <= 9'b0_0001_0000; 
  8'h2C: DECODED <= 9'b0_0010_0000; 
  8'h5B: DECODED <= 9'b0_0100_0000; 
  8'h5D: DECODED <= 9'b0_1000_0000; 
  default: DECODED <= 9'b1_0000_0000; 
  endcase 
 endmodule