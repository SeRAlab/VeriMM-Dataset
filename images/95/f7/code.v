module top_module(input wire clk,input wire rst_n,input wire [7:0] ir_low,input wire [7:0] rx_low,input wire ld_rat,input wire ld_pc,input wire pc_at,output wire [7:0] m_at);wire [7:0] low_sum; 
  wire [7:0] pc_plus_one; 
  reg [7:0] rat; 
  reg [7:0] pc; 
  always @(negedge rst_n, posedge clk) 
  begin: p_addr_rat_update 
  if (rst_n == 1'b0) 
  rat <= {8{1'b0}}; 
  else if (ld_rat == 1'b1) 
  rat <= low_sum; 
  end 
  always @(negedge rst_n, posedge clk) 
  begin: p_addr_pc_update 
  if (rst_n == 1'b0) 
  pc <= {8{1'b0}}; 
  else if (ld_rat == 1'b1) 
  pc <= pc_plus_one; 
  end 
  assign m_at = (pc_at == 1'b0) ? pc : rat; 
  assign low_sum = ir_low + rx_low; 
  assign pc_plus_one = m_at + 8'b00000001; 
 endmodule