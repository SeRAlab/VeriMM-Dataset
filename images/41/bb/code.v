module top_module(
  input         clock,
  input         reset,
  input  [31:0] io_ins_0,
  input  [31:0] io_ins_1,
  input         io_sel,
  output [31:0] io_out
);wire [31:0] _GEN_0;
  wire [31:0] _GEN_1;
  assign io_out = _GEN_0;
  assign _GEN_0 = _GEN_1;
  assign _GEN_1 = io_sel ? io_ins_1 : io_ins_0;
endmodule