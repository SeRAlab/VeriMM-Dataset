module top_module(input clk,input rst_n,input en,output reg sel_data,output reg [3:0] num);parameter bps_div = 13'd5207, 
  bps_div2 = 13'd2603; 
  reg flag; 
 always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  flag <= 0; 
  else 
  if(en) 
  flag <= 1; 
  else 
  if(num == 4'd10) 
  flag <= 0; 
  reg [12:0] cnt; 
 always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  cnt <= 13'd0; 
  else 
  if(flag && cnt < bps_div) 
  cnt <= cnt + 1'b1; 
  else 
  cnt <= 13'd0; 
 always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  num <= 4'd0; 
  else 
  if(flag && sel_data) 
  num <= num +1'b1; 
  else 
  if(num == 4'd10) 
  num <= 1'd0; 
 always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  sel_data <= 1'b0; 
  else 
  if(cnt == bps_div2) 
  sel_data <= 1'b1; 
  else 
  sel_data <= 1'b0; 
 endmodule