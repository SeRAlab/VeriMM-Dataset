module top_module(input d1,input d2,clk,clr,output reg q1,output reg q2);always @(posedge clk or posedge clr) 
  if (clr) begin 
  q1 <= 1'b0; 
  q2 <= 1'b0; 
  end else begin 
  q1 <= d1; 
  q2 <= d2; 
  end 
 endmodule