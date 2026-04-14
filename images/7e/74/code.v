module top_module(input clk,reset,output y,z);reg [3:0]cnt; 
 assign y=cnt[2]; 
 assign z=cnt[3]; 
 always@(negedge clk,posedge reset) begin 
  if(reset) 
  cnt<=0; 
  else 
  cnt<=cnt+1'b1; 
  end 
 endmodule