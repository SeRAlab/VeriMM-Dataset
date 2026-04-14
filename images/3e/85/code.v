module temperature_sensor_controller (
    input clk,
    input reset,
    input [7:0] temperature,
    output reg over_threshold
);
    parameter THRESHOLD = 8'd75; // Temperature threshold

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            over_threshold <= 0; // Reset output
        end else begin
            if (temperature > THRESHOLD) begin
                over_threshold <= 1; // Set output if above threshold
            end else begin
                over_threshold <= 0; // Clear output if below threshold
            end
        end
    end
endmodule