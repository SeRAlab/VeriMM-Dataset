module top_module(clk ,rst_n ,cbf_4x4_i ,cbf_u_4x4_i ,cbf_v_4x4_i ,qp_left_i ,qp_flag_o);input clk ; 
 input rst_n ; 
 input cbf_4x4_i ; 
 input cbf_u_4x4_i ; 
 input cbf_v_4x4_i ; 
 input qp_left_i ; 
 output qp_flag_o ; 
 reg qp_flag_o ; 
 wire modified_flag = !(cbf_4x4_i ||cbf_u_4x4_i ||cbf_v_4x4_i ); 
 always@(posedge clk or negedge rst_n) begin 
  if(!rst_n) 
  qp_flag_o <= 1'b0 ; 
  else if(modified_flag) 
  qp_flag_o <= qp_left_i ; 
  else 
  qp_flag_o <= 1'b0 ; 
 end 
 endmodule