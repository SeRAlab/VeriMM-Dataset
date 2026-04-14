module top_module(w_bus_eight_out, w_bus_eight_in);output [7:0] w_bus_eight_out; 
  input [7:0] w_bus_eight_in; 
  assign w_bus_eight_out = w_bus_eight_in + 1; 
 endmodule