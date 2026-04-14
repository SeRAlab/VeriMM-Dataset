module top_module(
  input   clock,
  input   reset,
  input   io_input,
  output  io_result
);assign io_result = io_input ? 1'h0 : 1'h1; 
endmodule