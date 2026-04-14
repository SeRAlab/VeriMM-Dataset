module top_module(a, b, yuu, yus, ysu, yss);input [7:0] a, b; 
 output [15:0] yuu, yus, ysu, yss; 
 assign yuu = {{8{1'b0}}, a} | {{8{1'b0}}, b}; 
 assign yus = {{8{1'b0}}, a} | {{8{1'b0}}, b}; 
 assign ysu = {{8{1'b0}}, a} | {{8{1'b0}}, b}; 
 assign yss = {{8{a[7]}}, a} | {{8{b[7]}}, b}; 
 endmodule