module top_module(reg_clk, reg_addr, reg_data, reg_wr,increment_clk, increment);parameter ADDR = 1; 
 input reg_clk; 
 input [15:0] reg_addr; 
 inout [31:0] reg_data; 
 input reg_wr; 
 input increment_clk; 
 input increment; 
 reg [31:0] my_value; 
 initial my_value = 32'h0; 
 reg [31:0] value; 
 reg reset; 
 initial reset = 0; 
 always @(posedge increment_clk) 
 begin 
  my_value <= reset ? 0 : my_value + increment; 
 end 
 always @(posedge reg_clk) 
 begin 
  value <= my_value; 
  if (reg_addr == ADDR && reg_wr) 
  reset <= 1; 
  else if (reset) 
  reset <= 0; 
 end 
 assign reg_data = (reg_addr == ADDR && !reg_wr) ? value : 32'hZZ; 
 endmodule