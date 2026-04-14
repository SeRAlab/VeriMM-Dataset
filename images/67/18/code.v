module top_module(clk, d_in_1, d_out_1, addr_1, rd_1, wr_1, d_in_2, d_out_2, addr_2, rd_2, wr_2);input clk; 
  input [15:0]d_in_1; 
  output reg [15:0]d_out_1=0; 
  input [7:0]addr_1; 
  input rd_1; 
  input wr_1; 
  input [15:0]d_in_2; 
  output reg [15:0]d_out_2=0; 
  input [7:0]addr_2; 
  input rd_2; 
  input wr_2; 
  reg [7:0] ram [0:31]; 
 always @(negedge clk) 
 begin 
  if (rd_1) begin 
  d_out_1[7:0] <= ram[addr_1]; 
  d_out_1[15:8] <= ram[addr_1+1]; 
  end 
  else if(wr_1) begin 
  ram[addr_1] <= d_in_1[7:0]; 
  ram[addr_1+1] <= d_in_1[15:8]; 
  end 
  else if (rd_2) begin 
  d_out_2[7:0] <= ram[addr_2]; 
  d_out_2[15:8] <= ram[addr_2+1]; 
  end 
  else if(wr_2) begin 
  ram[addr_2] <= d_in_2[7:0]; 
  ram[addr_2+1] <= d_in_2[15:8]; 
  end 
 end 
 endmodule