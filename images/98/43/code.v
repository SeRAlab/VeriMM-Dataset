module top_module(Y);output reg Y = 1; 
 reg [3:0] cnt = 1; 
 reg trig = 0; 
 initial trig <= 1; 
 always @(cnt, trig) begin 
  Y <= |cnt; 
  cnt <= cnt + |cnt; 
 end 
 endmodule