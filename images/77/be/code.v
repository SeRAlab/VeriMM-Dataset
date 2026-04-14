module top_module(input i,input [2:0] sel,output [7:0] o);assign o = i << sel; 
 endmodule