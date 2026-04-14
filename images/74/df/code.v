module top_module(bus, line);input [7:0] bus;
  output line;
  assign line = ~bus[0];
endmodule