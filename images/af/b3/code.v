module top_module(output reg signed [35:0] P,input signed [17:0] A,input signed [17:0] B,input C,input CE,input R);always @(posedge C) 
  if(R) 
  P <= 36'sd0; 
  else if(CE) 
  begin 
  P <= A * B; 
  end 
 endmodule