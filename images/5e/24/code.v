module top_module(input Clk,input stall,input flush,input [31:0]Branch_addr_EX,input [5:0]op_EX,input [2:0]Condition_EX,input Branch_EX,input MemWrite_EX,input RegWrite_EX,input MemRead_EX,input [31:0]MemData_EX,input [31:0]WBData_EX,input Less_EX,input Zero_EX,input Overflow_EX,input [4:0]Rd_EX,output reg [31:0]Branch_addr_MEM,output reg [5:0]op_MEM,output reg [2:0]Condition_MEM,output reg Branch_MEM,output reg MemWrite_MEM,output reg RegWrite_MEM,output reg MemRead_MEM,output reg [31:0]MemData_MEM,output reg [31:0]WBData_MEM,output reg Less_MEM,output reg Zero_MEM,output reg Overflow_MEM,output reg [4:0]Rd_MEM);initial 
 begin 
 Branch_addr_MEM=32'b0; 
 op_MEM=6'b0; 
 Condition_MEM=3'b0; 
 Branch_MEM=0; 
 MemWrite_MEM=0; 
 RegWrite_MEM=0; 
 MemRead_MEM=0; 
 MemData_MEM=2'b0; 
 WBData_MEM=32'b0; 
 Less_MEM=0; 
 Zero_MEM=0; 
 Overflow_MEM=0; 
 Rd_MEM=5'b0; 
 end 
 always @(negedge Clk)begin 
  if(flush)begin 
  op_MEM <= 0; 
  Condition_MEM <= 0; 
  Branch_MEM <= 0; 
  MemWrite_MEM <= 0; 
  RegWrite_MEM <= 0; 
  MemRead_MEM <= 0; 
  MemData_MEM <= 0; 
  WBData_MEM <= 0; 
  Less_MEM <= 0; 
  Zero_MEM <= 0; 
  Overflow_MEM <= 0; 
  Rd_MEM <= 0; 
  end 
  else if(!stall)begin 
  Branch_addr_MEM <= Branch_addr_EX; 
  op_MEM <= op_EX; 
  Condition_MEM <= Condition_EX; 
  Branch_MEM <= Branch_EX; 
  MemWrite_MEM <= MemWrite_EX; 
  RegWrite_MEM <= RegWrite_EX; 
  MemRead_MEM <= MemRead_EX; 
  MemData_MEM <= MemData_EX; 
  WBData_MEM <= WBData_EX; 
  Less_MEM <= Less_EX; 
  Zero_MEM <= Zero_EX; 
  Overflow_MEM <= Overflow_EX; 
  Rd_MEM <= Rd_EX; 
  end 
 end 
 endmodule