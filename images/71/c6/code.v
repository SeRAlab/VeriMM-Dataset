module top_module(input sys_clk,input sys_rst,input stb,input eack,input we,output stbm,output reg ack);wire read = eack & ~we; 
 wire write = eack & we; 
 reg ack_read2; 
 reg ack_read1; 
 reg ack_read0; 
 always @(posedge sys_clk) begin 
  if(sys_rst) begin 
  ack_read2 <= 1'b0; 
  ack_read1 <= 1'b0; 
  ack_read0 <= 1'b0; 
  end else begin 
  ack_read2 <= read; 
  ack_read1 <= ack_read2; 
  ack_read0 <= ack_read1; 
  end 
 end 
 reg ack0; 
 always @(posedge sys_clk) begin 
  if(sys_rst) begin 
  ack0 <= 1'b0; 
  ack <= 1'b0; 
  end else begin 
  ack <= ack_read0|write; 
  end 
 end 
 reg mask; 
 assign stbm = stb & ~mask; 
 always @(posedge sys_clk) begin 
  if(sys_rst) 
  mask <= 1'b0; 
  else begin 
  if(eack) 
  mask <= 1'b1; 
  if(ack) 
  mask <= 1'b0; 
  end 
 end 
 endmodule