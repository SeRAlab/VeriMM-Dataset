module top_module(input clk,input rst,input [4:0] reg_R_addr,input [4:0] reg_W_addr,input [31:0] wdata,input [31:0] pc_i,input reg_we,input EPCWrite,input CauseWrite,input [1:0] IntCause,output [31:0] rdata,output [31:0] epc_o);reg [31:0] register[12:14]; 
 integer i; 
 assign rdata = register[reg_R_addr]; 
 assign epc_o = register[14]; 
 always @(posedge clk or posedge rst) 
  if (rst == 1)begin 
  for (i=12;i<14;i=i+1) 
  register[i] <= 0; 
  end else begin 
  if (reg_we) 
  register[reg_W_addr] <= wdata; 
  if (EPCWrite == 1) 
  register[14] <= pc_i; 
  if (CauseWrite == 1) 
  register[13] <= IntCause; 
  end 
 endmodule