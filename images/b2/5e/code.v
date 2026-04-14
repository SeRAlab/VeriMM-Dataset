module top_module(
    input slowest_sync_clk,
    input ext_reset_in,
    input aux_reset_in,
    input mb_debug_sys_rst,
    input dcm_locked,
    output reg mb_reset,
    output reg [0:0] bus_struct_reset,
    output reg [0:0] peripheral_reset,
    output reg [0:0] interconnect_aresetn,
    output reg [0:0] peripheral_aresetn
);// Debug system reset
always @* begin
    mb_reset = mb_debug_sys_rst; // Assign from debug reset

    // External reset
    peripheral_reset = ext_reset_in; 
    interconnect_aresetn = ~ext_reset_in;

    // Auxiliary reset
    bus_struct_reset = aux_reset_in;
    peripheral_aresetn = aux_reset_in;

    // Processing system reset based on slowest_sync_clk
    mb_reset = slowest_sync_clk ? 1'b0 : 1'b1;
    bus_struct_reset = slowest_sync_clk ? 1'b0 : 1'b1;
    peripheral_reset = slowest_sync_clk ? 1'b0 : 1'b1;
    interconnect_aresetn = slowest_sync_clk ? 1'b1 : 1'b0;
    peripheral_aresetn = slowest_sync_clk ? 1'b1 : 1'b0;
end

endmodule