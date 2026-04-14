module power_gating_controller (
    input wire control_signal,
    input wire power_active,
    output wire power_gated
);
    assign power_gated = control_signal & power_active;
endmodule