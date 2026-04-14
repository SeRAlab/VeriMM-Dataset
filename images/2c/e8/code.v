module temperature_sensor_controller (
    input wire clk,
    input wire reset,
    input wire [4:0] temperature, // 5-bit temperature input
    output reg warning // Warning signal
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        warning <= 1'b0; // Reset warning
    end else begin
        if (temperature > 25) begin
            warning <= 1'b1; // Set warning if temperature exceeds 25
        end else begin
            warning <= 1'b0; // Clear warning otherwise
        end
    end
end

endmodule