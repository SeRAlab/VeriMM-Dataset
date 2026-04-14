module top_module( input ex_mem_reg_write,input mem_wb_reg_write,input [4:0] ex_mem_dst_reg,input [4:0] mem_wb_dst_reg,input [4:0] rs,input [4:0] rt,output reg [3:0] forward_control);reg ex_mem_dst_reg_is_not_zero; 
  reg mem_wb_dst_reg_is_not_zero; 
  always @* begin 
  ex_mem_dst_reg_is_not_zero = |ex_mem_dst_reg; 
  mem_wb_dst_reg_is_not_zero = |mem_wb_dst_reg; 
  forward_control = 4'h0; 
  if (ex_mem_reg_write & ex_mem_dst_reg_is_not_zero) begin 
  if (ex_mem_dst_reg == rs) 
  forward_control[0] = 1'b1; 
  else 
  forward_control[0] = 1'b0; 
  if (ex_mem_dst_reg == rt) 
  forward_control[1] = 1'b1; 
  else 
  forward_control[1] = 1'b0; 
  end 
  else 
  forward_control[1:0] = 2'b00; 
  if (mem_wb_reg_write & mem_wb_dst_reg_is_not_zero) begin 
  if ((mem_wb_dst_reg == rs) & (ex_mem_dst_reg != rs)) 
  forward_control[2] = 1'b1; 
  else 
  forward_control[2] = 1'b0; 
  if ((mem_wb_dst_reg == rt) & (ex_mem_dst_reg != rt)) 
  forward_control[3] = 1'b1; 
  else 
  forward_control[3] = 1'b0; 
  end 
  else 
  forward_control[3:2] = 2'b00; 
  end 
 endmodule