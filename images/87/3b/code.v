module top_module(
  input   clock,
  input   reset,
  output  io_in_ready,
  input   io_in_valid,
  input  [1:0] io_in_bits_resp,
  input  [4:0] io_in_bits_id,
  input   io_in_bits_user,
  input   io_out_ready,
  output  io_out_valid,
  output [1:0] io_out_bits_resp,
  output [4:0] io_out_bits_id,
  output  io_out_bits_user
);assign io_in_ready = io_out_ready;
  assign io_out_valid = io_in_valid;
  assign io_out_bits_resp = io_in_bits_resp;
  assign io_out_bits_id = io_in_bits_id;
  assign io_out_bits_user = io_in_bits_user;endmodule