module top_module(input clk,input PB,output reg PB_state);reg PB_sync_0; 
 reg PB_sync_1; 
 reg [1:0] PB_cnt; 
 always @(posedge clk) PB_sync_0 <= ~PB; 
 always @(posedge clk) PB_sync_1 <= PB_sync_0; 
 wire PB_idle = (PB_state==PB_sync_1); 
 wire PB_cnt_max = &PB_cnt; 
 always @(posedge clk) begin 
  if(PB_idle) PB_cnt <= 2'd0; 
  else begin 
  PB_cnt <= PB_cnt + 2'd1; 
  if(PB_cnt_max) PB_state <= ~PB_state; 
  end 
 end 
 endmodule