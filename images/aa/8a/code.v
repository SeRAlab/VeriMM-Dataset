module top_module(
  input slowest_sync_clk,
  input ext_reset_in,
  input aux_reset_in,
  input mb_debug_sys_rst,
  input dcm_locked,
  output reg mb_reset,
  output reg [0:0]bus_struct_reset,
  output reg [0:0]peripheral_reset,
  output reg [0:0]interconnect_aresetn,
  output reg [0:0]peripheral_aresetn
);always @(posedge slowest_sync_clk) begin
    if (ext_reset_in || aux_reset_in || mb_debug_sys_rst || !dcm_locked) begin
      mb_reset <= 1;
      bus_struct_reset <= 1;
      peripheral_reset <= 1;
      interconnect_aresetn <= 1;
      peripheral_aresetn <= 1;
    end
    else begin
      mb_reset <= 0;
      bus_struct_reset <= 0;
      peripheral_reset <= 0;
      interconnect_aresetn <= 0;
      peripheral_aresetn <= 0;
    end
  end
endmodule