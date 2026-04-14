module top_module(
    input slowest_sync_clk,
    input ext_reset_in,
    input aux_reset_in,
    input mb_debug_sys_rst,
    input dcm_locked,
    output reg mb_reset,                        // Change mb_reset to a reg type
    output reg [0:0]bus_struct_reset,
    output reg [0:0]peripheral_reset,
    output reg [0:0]interconnect_aresetn,
    output reg [0:0]peripheral_aresetn
);always @(posedge slowest_sync_clk) begin
        bus_struct_reset <= ext_reset_in | mb_debug_sys_rst;
        peripheral_reset <= aux_reset_in | mb_debug_sys_rst;
        interconnect_aresetn <= ~mb_debug_sys_rst;
        peripheral_aresetn <= ~mb_debug_sys_rst;
        mb_reset <= ~mb_debug_sys_rst;            // Corrected value assignment for mb_reset
    end

endmodule