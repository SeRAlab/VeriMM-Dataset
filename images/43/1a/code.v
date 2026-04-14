module top_module(input rst_n,input clk,input clken,input d,input dump,output out,output valid);reg[15:0] r; 
 reg[15:0] next; 
 assign out = r[15]; 
 assign valid = (next == 16'b1000000000001101); 
 always @(*) begin 
  if (dump || out == d) 
  next = { r[14:0], 1'b0 }; 
  else 
  next = { !r[14], r[13:2], !r[1], r[0], 1'b1 }; 
 end 
 always @(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin 
  r <= 16'hffff; 
  end else if (clken) begin 
  r <= next; 
  end 
 end 
 endmodule