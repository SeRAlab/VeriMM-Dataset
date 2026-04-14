module top_module(input rst,input clk,input [19:0] inst_in,input i_fetch,input [5:0] a_src,input [10:0] pc_in,output [10:0] pc_out,output reg branch,output skip,output [3:0] lcount);reg [10:0] r_loop_st; 
  reg [10:0] r_loop_end; 
  reg [5:0] r_loop_cnt; 
  reg r_loop_ena; 
  always @(posedge rst or posedge clk) 
  begin 
  if (rst) begin 
  r_loop_st <= 11'd0; 
  r_loop_end <= 11'd0; 
  r_loop_cnt <= 6'd0; 
  r_loop_ena <= 1'b0; 
  branch <= 1'b0; 
  end else begin 
  if (inst_in[19:17] == 3'b000) begin 
  r_loop_st = pc_in; 
  r_loop_end = inst_in[10:0]; 
  if (inst_in[11]) begin 
  r_loop_cnt = a_src[5:0] - 6'd1; 
  r_loop_ena = ~skip; 
  end else begin 
  r_loop_cnt = 6'd15; 
  r_loop_ena = 1'b1; 
  end 
  end 
  if (r_loop_ena) begin 
  if (i_fetch) begin 
  if (r_loop_end == pc_in) 
  if (r_loop_cnt == 6'd0) begin 
  branch <= 1'b0; 
  r_loop_ena <= 1'b0; 
  end else begin 
  branch <= 1'b1; 
  r_loop_cnt <= r_loop_cnt - 6'd1; 
  end 
  else 
  branch <= 1'b0; 
  end 
  end else begin 
  branch <= 1'b0; 
  end 
  end 
  end 
  assign pc_out = r_loop_st; 
  assign skip = (a_src[5:0] == 6'd0) ? inst_in[11] : 1'b0; 
  assign lcount = r_loop_cnt[3:0]; 
 endmodule