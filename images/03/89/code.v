module power_gating_controller(
    input enable,
    input power_gate_control,
    input sensor_input,
    output power_gate_signal
);
    assign power_gate_signal = enable & power_gate_control & sensor_input;
endmodule