module top_module(reset,clka,out);input reset; 
 input clka; 
 output out; 
 reg out; 
 always @(posedge clka or posedge reset) 
  if(reset) 
  out = 0; 
  else 
  begin 
  out = ~out; 
  $display("saw a clk at %d, out is %b\n",$time,out); 
  end 
 endmodule