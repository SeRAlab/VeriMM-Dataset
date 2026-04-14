module top_module(
  input   clock,
  input   reset,
  output  io_in_0_ready,
  input   io_in_0_valid,
  input   io_in_0_bits,
  output  io_in_1_ready,
  input   io_in_1_valid,
  input   io_in_1_bits,
  input   io_out_ready,
  output  io_out_valid,
  output  io_out_bits,
  output  io_chosen
);wire  GEN_0;
  wire  GEN_1;
  wire  grant_1;
  wire  T_58;
  wire  T_60;
  wire  T_61;
  assign io_in_0_ready = io_out_ready;
  assign io_in_1_ready = T_58;
  assign io_out_valid = T_61;
  assign io_out_bits = GEN_1;
  assign io_chosen = GEN_0;
  assign GEN_0 = io_in_0_valid ? 1'h0 : 1'h1;
  assign GEN_1 = io_in_0_valid ? io_in_0_bits : io_in_1_bits;
  assign grant_1 = io_in_0_valid == 1'h0;
  assign T_58 = grant_1 & io_out_ready;
  assign T_60 = grant_1 == 1'h0;
  assign T_61 = T_60 | io_in_1_valid;endmodule