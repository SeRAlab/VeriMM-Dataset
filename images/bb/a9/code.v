module top_module(slowest_sync_clk, ext_reset_in, aux_reset_in, mb_debug_sys_rst, dcm_locked, mb_reset, bus_struct_reset, peripheral_reset, interconnect_aresetn, peripheral_aresetn);input slowest_sync_clk;
  input ext_reset_in;
  input aux_reset_in;
  input mb_debug_sys_rst;
  input dcm_locked;
  output mb_reset;
  output [0:0]bus_struct_reset;
  output [0:0]peripheral_reset;
  output [0:0]interconnect_aresetn;
  output [0:0]peripheral_aresetn;

  assign mb_reset = ext_reset_in & aux_reset_in & mb_debug_sys_rst & dcm_locked;
  assign bus_struct_reset[0] = ext_reset_in;
  assign peripheral_reset[0] = ext_reset_in;
  assign interconnect_aresetn[0] = ext_reset_in;
  assign peripheral_aresetn[0] = ext_reset_in;

endmodule