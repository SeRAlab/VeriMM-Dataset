module top_module(input clk_in,input rst_async_n,input en_clk_div8,output rst_sync_n,output clk_out,output clk_div2,output clk_div4,output clk_div8,output clk_div8_proc);reg [2:0] counter; 
 reg synch_rst_reg1_n, synch_rst_reg2_n; 
 reg en_clk_div8_reg; 
 always@(posedge clk_in)begin 
  if(!rst_async_n) 
  counter <= 0; 
  else 
  counter <= counter-1; 
 end 
 assign clk_out = clk_in; 
 assign clk_div2 = counter[0]; 
 assign clk_div4 = counter[1]; 
 assign clk_div8 = counter[2]; 
 always@(posedge clk_div8, negedge rst_async_n)begin 
  if(!rst_async_n)begin 
  en_clk_div8_reg <= 0; 
  end 
  else begin 
  en_clk_div8_reg <= en_clk_div8; 
  end 
 end 
 assign clk_div8_proc = en_clk_div8_reg?counter[2]:1'b0; 
 always@(posedge clk_div8, negedge rst_async_n)begin 
  if(!rst_async_n)begin 
  synch_rst_reg1_n <= 1'b0; 
  synch_rst_reg2_n <= 1'b0; 
  end 
  else begin 
  synch_rst_reg1_n <= 1'b1; 
  synch_rst_reg2_n <= synch_rst_reg1_n; 
  end 
 end 
 assign rst_sync_n = synch_rst_reg2_n; 
 endmodule