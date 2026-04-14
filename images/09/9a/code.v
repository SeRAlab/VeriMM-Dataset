module power_gating_controller (
    input wire power_enable,
    input wire control,
    output wire power_signal
);
    assign power_signal = power_enable & control;
endmodule