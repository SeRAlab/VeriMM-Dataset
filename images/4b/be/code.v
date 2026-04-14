module top_module(input clk,input stall,input flush,input [31:0] MemData_Mem,input [3:0] Rd_write_byte_en_Mem,input [31:0] WBData_Mem,input MemRead_Mem,input RegWrite_Mem,input [4:0] Rd_Mem,output reg [31:0] MemData_Wr,output reg [3:0] Rd_write_byte_en_Wr,output reg [31:0] WBData_Wr,output reg MemRead_Wr,output reg RegWrite_Wr,output reg [4:0] Rd_Wr);initial 
 begin 
 MemData_Wr=32'b0; 
 Rd_write_byte_en_Wr=4'b0; 
 WBData_Wr=32'b0; 
 MemRead_Wr=0; 
 RegWrite_Wr=0; 
 Rd_Wr=5'b0; 
 end 
 always@(negedge clk)begin 
  if(flush)begin 
  MemData_Wr<= 32'h00000000; 
  Rd_write_byte_en_Wr<= 4'b0000; 
  WBData_Wr<= 32'b0; 
  MemRead_Wr<= 0; 
  RegWrite_Wr<= 0; 
  Rd_Wr<= 4'b0000; 
  end 
  else if(!stall)begin 
  MemData_Wr<=MemData_Mem; 
  Rd_write_byte_en_Wr<=Rd_write_byte_en_Mem; 
  WBData_Wr<=WBData_Mem; 
  MemRead_Wr<=MemRead_Mem; 
  RegWrite_Wr<=RegWrite_Mem; 
  Rd_Wr<= Rd_Mem; 
  end 
 end 
 endmodule