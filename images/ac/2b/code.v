module top_module(
  input [15:0] a_m,
  input [4:0] tmp_cnt,
  output [15:0] a_m_shift);assign a_m_shift = a_m << tmp_cnt;endmodule