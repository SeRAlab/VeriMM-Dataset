module top_module(input [2:0] reg_read_adr1_d,input [2:0] reg_read_adr2_d,input [2:0] reg_read_adr1_e,input [2:0] reg_read_adr2_e,input [2:0] reg_write_adr_e,input mem_to_reg_e,input reg_write_m,input [2:0] reg_write_adr_m,input reg_write_w,input [2:0] reg_write_adr_w,input PC_source,output reg stall_f,output reg stall_d,output reg flush_d,output reg flush_e,output reg [1:0] forward1_e,output reg [1:0] forward2_e);always @(*) begin 
  if ((reg_write_adr_m == reg_read_adr1_e) && reg_write_m) 
  forward1_e = 2'h1; 
  else if ((reg_write_adr_w == reg_read_adr1_e) && reg_write_w) 
  forward1_e = 2'h2; 
  else 
  forward1_e = 2'h0; 
  if ((reg_write_adr_m == reg_read_adr2_e) && reg_write_m) 
  forward2_e = 2'h1; 
  else if ((reg_write_adr_w == reg_read_adr2_e) && reg_write_w) 
  forward2_e = 2'h2; 
  else 
  forward2_e = 2'h0; 
  end 
  reg stallCompare; 
  always @(*) begin 
  if ((reg_write_adr_e == reg_read_adr1_d) || (reg_write_adr_e == reg_read_adr2_d)) 
  stallCompare <= 1; 
  else 
  stallCompare <= 0; 
  stall_f <= stallCompare && mem_to_reg_e; 
  stall_d <= stallCompare && mem_to_reg_e; 
  flush_e <= stallCompare && mem_to_reg_e; 
  flush_d <= PC_source; 
  end 
 endmodule