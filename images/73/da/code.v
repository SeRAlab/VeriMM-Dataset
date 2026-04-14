module top_module(input wire a,input wire b,output reg q);wire tmp; 
 assign tmp = ~(a&b); 
 wire tmp2 = tmp; 
 reg tmp3; 
 always @*tmp3 = tmp2; 
 always @* q = tmp3; 
 endmodule