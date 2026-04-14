module dvfs_controller(
    input clk,
    input reset,
    input [3:0] voltage_level, // Voltage level (0000 to 1111)
    input [3:0] frequency_level, // Frequency level (0000 to 1111)
    output reg control_signal // Control signal to adjust voltage and frequency
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 1'b0;
        end else begin
            // Simple control logic based on input levels
            if (voltage_level > 4'b0000 && frequency_level > 4'b0000) begin
                control_signal <= 1'b1; // Activate control signal
            end else begin
                control_signal <= 1'b0; // Deactivate control signal
            end
        end
    end
endmodule