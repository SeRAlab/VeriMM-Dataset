module top_module(input clk, output h_sync, output v_sync, output blank,input gfx_clk, output[9:0] x, output[9:0] y, input rst);reg[9:0] hcount, vcount; 
 assign h_sync = hcount < 96 ? 1'b0 : 1'b1; 
 assign v_sync = vcount < 2 ? 1'b0 : 1'b1; 
 assign blank = h_sync & v_sync; 
 assign x = hcount - 10'd144; 
 assign y = vcount - 10'd34; 
 always @(posedge gfx_clk) 
 begin 
  if(hcount < 800) 
  hcount <= hcount+10'd1; 
  else begin 
  hcount <= 0; 
  vcount <= vcount+10'd1; 
  end 
  if(vcount == 525) 
  vcount <= 0; 
  if(rst) begin 
  hcount <= 0; 
  vcount <= 0; 
  end 
 end 
 endmodule