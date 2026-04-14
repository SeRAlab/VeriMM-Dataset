module linear_voltage_regulator (
    input wire [7:0] reference_voltage, // 8-bit reference voltage
    input wire [7:0] feedback_voltage,   // 8-bit feedback voltage
    output wire control_signal            // control signal output
);
    assign control_signal = (feedback_voltage < reference_voltage) ? 1'b1 : 1'b0;
endmodule