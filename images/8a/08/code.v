module top_module(input [7:0] a, output [7:0] z);parameter PARAM = 5; 
  wire [7:0] z0; wire [7:0] z1; 
  assign z = a; 
 endmodule