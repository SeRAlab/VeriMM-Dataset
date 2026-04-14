module linear_voltage_regulator(
    input [3:0] desired_voltage,  // 4-bit input for voltage level (0 to 15)
    input [3:0] actual_voltage,    // 4-bit input for actual voltage level (0 to 15)
    output reg control_signal       // control signal for pass transistor
);

always @(*) begin
    if (actual_voltage < desired_voltage) begin
        control_signal = 1'b1; // Turn on pass transistor
    end else begin
        control_signal = 1'b0; // Turn off pass transistor
    end
end

endmodule