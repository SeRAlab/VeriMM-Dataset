module top_module(input clk,input rst,output [19:0] umi_adr_o,input [15:0] umi_dat_i,output reg umi_stb_o,output umi_by_o,input umi_ack_i,input flush,input load_cs_ip,input [15:0] requested_cs,input [15:0] requested_ip,output reg [15:0] cs,output reg [15:0] ip,output reg [15:0] fifo_dat_o,output reg wr_fifo,input fifo_full);wire stalled; 
 assign stalled = flush || load_cs_ip || fifo_full; 
 assign umi_adr_o = (cs << 4) + ip; 
 assign umi_by_o = 1'b0; 
 always @(posedge clk) 
  if (rst) begin 
  cs <= 16'hf000; 
  ip <= 16'hfff0; 
  end 
  else begin 
  if (flush) begin 
  cs <= requested_cs; 
  ip <= requested_ip; 
  end 
  else if (load_cs_ip) begin 
  cs <= requested_cs; 
  ip <= requested_ip; 
  end 
  else if (!stalled & umi_ack_i) 
  ip <= ip + 2; 
  end 
 always @(posedge clk) 
  if (rst) umi_stb_o <= 1'b0; 
  else umi_stb_o <= !stalled ? 1'b1 : (umi_ack_i ? 1'b0 : umi_stb_o); 
 always @(posedge clk) 
  if (rst) wr_fifo <= 1'b0; 
  else wr_fifo <= (!stalled & umi_ack_i); 
 always @(posedge clk) 
  if (rst) wr_fifo <= 1'b0; 
  else fifo_dat_o <= umi_dat_i; 
 endmodule