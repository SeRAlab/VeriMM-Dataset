module top_module(input [3:0] i,output [3:0] o);wire [4:0] fiveminus; 
 assign fiveminus = 5'd5 - {1'b0,i}; 
 assign o = ( !fiveminus[4]) ? fiveminus[3:0] : 4'b0; 
 endmodule