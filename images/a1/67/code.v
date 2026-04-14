module top_module(
  input   clock,
  input   reset,
  output  io_led,
  input   io_clk
);assign io_led = io_clk; 
endmodule