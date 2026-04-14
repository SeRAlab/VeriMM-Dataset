module top_module(clk, rst, cfg, status, full_empty, dma_req, dma_ack);input clk, rst; 
 input [7:0] cfg; 
 input [1:0] status; 
 input full_empty; 
 output dma_req; 
 input dma_ack; 
 reg dma_req_d; 
 reg dma_req_r1; 
 reg dma_req; 
 always @(cfg or status or full_empty) 
  case(cfg[5:4]) 
  2'h2: dma_req_d = cfg[0] & cfg[6] & (full_empty | (status == 2'h0)); 
  2'h1: dma_req_d = cfg[0] & cfg[6] & (full_empty | (status[1] == 1'h0)); 
  2'h0: dma_req_d = cfg[0] & cfg[6] & (full_empty | (status < 2'h3)); 
  2'h3: dma_req_d = cfg[0] & cfg[6] & full_empty; 
  endcase 
 always @(posedge clk) 
  dma_req_r1 <= #1 dma_req_d & !dma_ack; 
 always @(posedge clk or negedge rst) 
  if(!rst) dma_req <= #1 1'b0; 
  else 
  if(dma_req_r1 & dma_req_d & !dma_ack) dma_req <= #1 1'b1; 
  else 
  if(dma_ack) dma_req <= #1 1'b0; 
 endmodule