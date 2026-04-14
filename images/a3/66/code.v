module top_module(Saltoincond,instru,clk,RegDest,SaltoCond,LeerMem,MemaReg,ALUOp,EscrMem,FuenteALU,EscrReg);input [5:0]instru; 
 input clk; 
 output wire RegDest; 
 output wire SaltoCond; 
 output wire LeerMem; 
 output wire MemaReg; 
 output wire [1:0]ALUOp; 
 output wire EscrMem; 
 output wire FuenteALU; 
 output wire EscrReg; 
 output wire Saltoincond; 
 reg [9:0]aux; 
 always @ (*) 
 begin 
  case(instru) 
  6'b000_000: aux=10'b0100_100_010; 
  6'b100_011: aux=10'b00_1111_0000; 
  6'b101_011: aux=10'b0x1x001000; 
  6'b000_100: aux=10'b0x0x000101; 
  6'b111_111: aux=10'b00_1010_0000; 
  6'b111_110: aux=10'b00_0000_0101; 
  default: aux=10'b00_1010_0000; 
  endcase 
 end 
 assign Saltoincond = aux[9]; 
 assign RegDest = aux[8]; 
 assign FuenteALU = aux[7]; 
 assign MemaReg = aux[6]; 
 assign EscrReg = aux[5]; 
 assign LeerMem = aux[4]; 
 assign EscrMem = aux[3]; 
 assign SaltoCond = aux[2]; 
 assign ALUOp = aux[1:0]; 
 endmodule