module top_module(clk, wr_addr, wr_data, wr_enable, rd_addr, rd_data);input clk, wr_enable; 
 input [3:0] wr_addr, wr_data, rd_addr; 
 output reg [3:0] rd_data; 
 reg [3:0] memory [0:15]; 
 always @(posedge clk) begin 
  if (wr_enable) 
  memory[wr_addr] <= wr_data; 
  rd_data <= memory[rd_addr]; 
 end 
 endmodule