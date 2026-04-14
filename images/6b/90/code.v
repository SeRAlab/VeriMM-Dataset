module top_module(
  input   		 clock,
  input   		 reset,
  input  [31:0] io_jmp,
  input  [31:0] io_br,
  input  [1:0]  io_jmp_br_mux_sel,
  output [31:0] io_to_adder
);wire  _T_10;
  wire  _T_11;
  wire [31:0] _T_12;
  wire [31:0] _T_13;
  assign io_to_adder = _T_13;
  assign _T_10 = io_jmp_br_mux_sel == 2'h0;
  assign _T_11 = io_jmp_br_mux_sel == 2'h1;
  assign _T_12 = _T_11 ? io_br : io_jmp;
  assign _T_13 = _T_10 ? io_jmp : _T_12;
endmodule