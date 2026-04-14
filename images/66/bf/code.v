module top_module(F, C, A, B, FS);parameter WORD_WIDTH = 16; 
 parameter DR_WIDTH = 3; 
 parameter SB_WIDTH = DR_WIDTH; 
 parameter SA_WIDTH = DR_WIDTH; 
 parameter OPCODE_WIDTH = 7; 
 parameter INSTR_WIDTH = WORD_WIDTH; 
 output reg [WORD_WIDTH-1:0] F; 
 output reg C; 
 input [WORD_WIDTH-1:0] A, B; 
 input [3:0] FS; 
 always@(*) 
  case(FS) 
  4'b0000: {C, F} = A; 
  4'b0001: {C, F} = A+1; 
  4'b0010: {C, F} = A+B; 
  4'b0011: {C, F} = A+B+1; 
  4'b0100: {C, F} = A+(~B); 
  4'b0101: {C, F} = A+(~B)+1; 
  4'b0110: {C, F} = A-1; 
  4'b0111: {C, F} = A; 
  4'b1000: {C, F} = A&B; 
  4'b1001: {C, F} = A|B; 
  4'b1010: {C, F} = A^B; 
  4'b1011: {C, F} = (~A); 
  4'b1100: {C, F} = B; 
  4'b1101: {C, F} = (B>>1); 
  4'b1110: {C, F} = (B<<1); 
  4'b1111: {C, F} = (~B); 
  default:; 
  endcase 
 endmodule