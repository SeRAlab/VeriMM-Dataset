module top_module(input clk,input rst,input in,output [31:0] count_h,output [31:0] count_l,output detected);reg [31:0] ticks; 
  reg [31:0] t1; 
  reg [31:0] t2; 
  reg synced; 
  reg [31:0] r_count_h; 
  reg [31:0] r_count_l; 
  initial begin 
  ticks <= 0; 
  t1 <= 0; 
  t2 <= 0; 
  synced <= 0; 
  r_count_h <= 0; 
  r_count_l <= 0; 
  end 
  always @(posedge clk or posedge rst) begin 
  if(rst) begin 
  ticks <= 0; 
  end 
  else begin 
  ticks <= ticks + 1; 
  end 
  end 
  always @(negedge in or posedge rst) begin 
  if(rst) begin 
  t2 <= 0; 
  end 
  else begin 
  if(t1 > 0) begin 
  t2 <= ticks; 
  end 
  end 
  end 
  always @(posedge in or posedge rst) begin 
  if(rst) begin 
  t1 <= 0; 
  r_count_h <= 0; 
  r_count_l <= 0; 
  synced <= 0; 
  end 
  else begin 
  if(t2 > t1) begin 
  r_count_h = t2 - t1; 
  r_count_l = ticks - t2; 
  synced <= 1; 
  end 
  else begin 
  synced <= 0; 
  end 
  t1 <= ticks; 
  end 
  end 
  assign count_h = r_count_h; 
  assign count_l = r_count_l; 
  assign detected = (synced & in); 
 endmodule