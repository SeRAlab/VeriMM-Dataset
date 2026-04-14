module top_module(d,clk,reset,q);output q;
input d,clk,reset;
reg q;


always @(posedge clk)

if(reset)
 q=1'b0;
else
 q=d;endmodule