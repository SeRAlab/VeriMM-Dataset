module power_gating_controller(
    input wire enable,
    input wire power_signal,
    output wire gated_signal
);
    assign gated_signal = enable & power_signal;
endmodule