module top_module(
  input   clock,
  input   reset,
  input  [31:0] io_pc_4,
  input  [31:0] io_pc,
  input  [31:0] io_jmp_br,
  input  [1:0] io_pc_sel,
  output [31:0] io_to_pc
);wire  _T_12;
  wire  _T_13;
  wire  _T_14;
  wire [31:0] _T_15;
  wire [31:0] _T_16;
  wire [31:0] _T_17;
  assign io_to_pc = _T_17;
  assign _T_12 = io_pc_sel == 2'h0;
  assign _T_13 = io_pc_sel == 2'h1;
  assign _T_14 = io_pc_sel == 2'h2;
  assign _T_15 = _T_14 ? io_jmp_br : io_pc_4;
  assign _T_16 = _T_13 ? io_pc : _T_15;
  assign _T_17 = _T_12 ? io_pc_4 : _T_16;
endmodule