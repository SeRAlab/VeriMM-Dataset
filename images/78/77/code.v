module top_module(input RW0_clk,input [5:0] RW0_addr,input RW0_en,input RW0_wmode,input [3:0] RW0_wmask,input [79:0] RW0_wdata,output [79:0] RW0_rdata);reg [5:0] reg_RW0_addr; 
  reg [79:0] ram [63:0]; 
  `ifdef RANDOMIZE 
  integer initvar; 
  initial begin 
  #0.002 begin end 
  for (initvar = 0; initvar < 64; initvar = initvar+1) 
  ram[initvar] = {3 {$random}}; 
  reg_RW0_addr = {1 {$random}}; 
  end 
  `endif 
  integer i; 
  always @(posedge RW0_clk) 
  if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr; 
  always @(posedge RW0_clk) 
  if (RW0_en && RW0_wmode) begin 
  if (RW0_wmask[0]) ram[RW0_addr][19:0] <= RW0_wdata[19:0]; 
  if (RW0_wmask[1]) ram[RW0_addr][39:20] <= RW0_wdata[39:20]; 
  if (RW0_wmask[2]) ram[RW0_addr][59:40] <= RW0_wdata[59:40]; 
  if (RW0_wmask[3]) ram[RW0_addr][79:60] <= RW0_wdata[79:60]; 
  end 
  assign RW0_rdata = ram[reg_RW0_addr]; 
 endmodule