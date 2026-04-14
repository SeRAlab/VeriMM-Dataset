module top_module(clk_i,adr_i,dat_i,wr_i,dat_o);parameter [31:0] WIDTH = 8; 
 parameter [31:0] SIZE = 14; 
 input clk_i ; 
 output [(WIDTH - 1):0] dat_o ; 
 input [(WIDTH - 1):0] dat_i ; 
 input [(SIZE - 1):0] adr_i ; 
 input wr_i ; 
 reg [(WIDTH - 1):0] ram [((2<< (SIZE-1)) - 1):0] ; 
 reg [(SIZE - 1):0] rd_addr; 
 wire [(WIDTH - 1):0] dat_o; 
 always @ (posedge clk_i) 
 begin 
  if (wr_i == 1'b1) 
  ram[adr_i] <= dat_i; 
  rd_addr <= adr_i; 
 end 
 assign dat_o = ram[rd_addr]; 
 endmodule