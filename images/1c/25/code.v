module power_gating_controller(
    input wire power_ctrl,
    input wire status,
    output wire power_gated
);
    assign power_gated = power_ctrl & ~status;
endmodule