module top_module(
  input slowest_sync_clk,
  input ext_reset_in,
  input aux_reset_in,
  input mb_debug_sys_rst,
  input dcm_locked,
  output mb_reset,
  output [0:0]bus_struct_reset,
  output [0:0]peripheral_reset,
  output [0:0]interconnect_aresetn,
  output [0:0]peripheral_aresetn
);// Internal signals
  wire [0:0] bus_struct_reset_int;
  wire [0:0] peripheral_reset_int;
  wire [0:0] interconnect_aresetn_int;
  wire [0:0] peripheral_aresetn_int;

  // Reset logic
  assign mb_reset = ext_reset_in || aux_reset_in || mb_debug_sys_rst || !dcm_locked;
  assign bus_struct_reset = bus_struct_reset_int;
  assign peripheral_reset = peripheral_reset_int;
  assign interconnect_aresetn = interconnect_aresetn_int;
  assign peripheral_aresetn = peripheral_aresetn_int;

  // Peripheral reset signals
  assign peripheral_reset_int[0] = aux_reset_in; // Only 1-bit signal 
  // Removed peripheral_reset_int[1] and peripheral_reset_int[2] assignments since they are out of range.

  // Interconnect reset signals
  assign interconnect_aresetn_int[0] = !aux_reset_in; // Only 1-bit signal 
  // Removed interconnect_aresetn_int[1] and interconnect_aresetn_int[2] assignments since they are out of range.

  // Bus structure reset signals
  assign bus_struct_reset_int[0] = !ext_reset_in;

endmodule