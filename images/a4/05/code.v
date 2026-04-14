module top_module( 
  input         clock, 
  input         reset, 
  input         io_fifo_valid, 
  output        io_fifo_ready, 
  input  [15:0] io_fifo_data, 
  output        io_pe0_valid, 
  input         io_pe0_ready, 
  output [15:0] io_pe0_data, 
  output        io_pe1_valid, 
  input         io_pe1_ready, 
  output [15:0] io_pe1_data 
);wire  _GEN_3; 
  assign _GEN_3 = io_pe0_ready ? 1'h0 : io_pe1_ready; 
  assign io_fifo_ready = io_pe0_ready | io_pe1_ready; 
  assign io_pe0_valid = io_fifo_valid ? io_pe0_ready : 1'h0; 
  assign io_pe0_data = io_fifo_data; 
  assign io_pe1_valid = io_fifo_valid ? _GEN_3 : 1'h0; 
  assign io_pe1_data = io_fifo_data; 
endmodule