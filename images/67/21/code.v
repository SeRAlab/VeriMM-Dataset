module top_module(clk,rst,d_flits_m,v_d_flits_m,mem_done_access,d_m_areg_flits,v_d_m_areg_flits,d_m_areg_state);input clk; 
 input rst; 
 input [143:0] d_flits_m; 
 input v_d_flits_m; 
 input mem_done_access; 
 output [175:0] d_m_areg_flits; 
 output v_d_m_areg_flits; 
 output d_m_areg_state; 
 reg d_m_cstate; 
 reg [175:0] flits_reg; 
 assign v_d_m_areg_flits=d_m_cstate; 
 assign d_m_areg_state=d_m_cstate; 
 always@(posedge clk) 
 begin 
  if(rst||mem_done_access) 
  flits_reg<=175'h0000; 
 else if(v_d_flits_m) 
  flits_reg<=d_flits_m; 
 end 
 always@(posedge clk) 
 begin 
  if(rst||mem_done_access) 
  d_m_cstate<=1'b0; 
  else if(v_d_flits_m) 
  d_m_cstate<=1'b1; 
 end 
 assign d_m_areg_flits=flits_reg; 
 endmodule