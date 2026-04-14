module top_module(input rst,input clk,input clk_en ,input zero,output reg [14:0] eg_cnt);reg [1:0] eg_cnt_base; 
 always @(posedge clk, posedge rst) begin : envelope_counter 
  if( rst ) begin 
  eg_cnt_base <= 2'd0; 
  eg_cnt <=15'd0; 
  end 
  else begin 
  if( zero && clk_en ) begin 
  if( eg_cnt_base == 2'd2 ) begin 
  eg_cnt <= eg_cnt + 1'b1; 
  eg_cnt_base <= 2'd0; 
  end 
  else eg_cnt_base <= eg_cnt_base + 1'b1; 
  end 
  end 
 end 
 endmodule