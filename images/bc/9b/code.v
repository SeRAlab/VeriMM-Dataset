module top_module(input RW0_clk,input [8:0] RW0_addr,input RW0_en,input RW0_wmode,input [63:0] RW0_wdata,output [63:0] RW0_rdata);reg [8:0] reg_RW0_addr; 
  reg [63:0] ram [511:0]; 
  `ifdef RANDOMIZE 
  integer initvar; 
  initial begin 
  #0.002 begin end 
  for (initvar = 0; initvar < 512; initvar = initvar+1) 
  ram[initvar] = {2 {$random}}; 
  reg_RW0_addr = {1 {$random}}; 
  end 
  `endif 
  integer i; 
  always @(posedge RW0_clk) 
  if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr; 
  always @(posedge RW0_clk) 
  if (RW0_en && RW0_wmode) begin 
  ram[RW0_addr][63:0] <= RW0_wdata[63:0]; 
  end 
  assign RW0_rdata = ram[reg_RW0_addr]; 
 endmodule