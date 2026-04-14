module top_module(clk,Reset,Enable, Opcode,BSelector,Rd,RValue1,RValue2,ImmValue,MemRD,memWD,RegWrite,OPCODE,BSELECTOR,RD,RVALUE1,RVALUE2,IMMVALUE,MEMWD,MEMRD,REGWRITE);input wire clk, Reset, Enable; 
  input [4:0] Opcode; 
  input [0:0] BSelector; 
  input [4:0] Rd; 
  input [31:0] RValue1,RValue2; 
  input [31:0] ImmValue; 
  input [0:0] MemRD,memWD,RegWrite; 
  output reg[4:0] OPCODE; 
  output reg[0:0] REGWRITE,MEMWD,MEMRD; 
  output reg[0:0] BSELECTOR; 
  output reg[4:0] RD; 
  output reg[31:0] RVALUE1,RVALUE2,IMMVALUE; 
  initial begin 
  OPCODE=5'b11111; 
  BSELECTOR=1'd0; 
  RD=5'd0; 
  RVALUE1=32'd0; 
  RVALUE2=32'd0; 
  IMMVALUE=32'd0; 
  MEMWD=1'd0; 
  MEMRD=1'd0; 
  REGWRITE=1'd0; 
  end 
  always @ (negedge clk) begin 
  if(Reset)begin 
  OPCODE=5'b11111; 
  BSELECTOR=1'd0; 
  RD=5'd0; 
  RVALUE1=32'd0; 
  RVALUE2=32'd0; 
  IMMVALUE=32'd0; 
  MEMWD=1'd0; 
  MEMRD=1'd0; 
  REGWRITE=1'd0; 
  end 
  else if (Enable)begin 
  OPCODE=Opcode; 
  BSELECTOR=BSelector; 
  RVALUE1=RValue1; 
  RVALUE2=RValue2; 
  IMMVALUE=ImmValue; 
  MEMWD=memWD; 
  MEMRD=MemRD; 
  REGWRITE=RegWrite; 
  RD=Rd; 
  end 
  end 
 endmodule