module top_module(q,d,rst_n,clk,ini_state);output reg q;
input clk,rst_n,d,ini_state;
always @(posedge clk or negedge rst_n)  
 if (~rst_n)  
 q <= ini_state;       
 else  
 q <= d;endmodule