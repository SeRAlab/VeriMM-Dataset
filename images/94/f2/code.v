module top_module(locked,reset);input locked; 
 output reset; 
 assign reset = ~locked; 
 endmodule