module power_gating_controller(
    input wire control_signal,
    input wire power_state,
    output wire power_gated_signal
);
    assign power_gated_signal = control_signal & ~power_state;
endmodule