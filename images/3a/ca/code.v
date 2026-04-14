module temperature_shutdown (
    input clk,
    input rst_n,
    input enable,
    input [7:0] temperature, // 8-bit temperature input
    input [7:0] threshold,   // 8-bit threshold input
    output reg shutdown       // shutdown signal
);

reg [7:0] last_temperature;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        last_temperature <= 8'b0;
        shutdown <= 1'b0;
    end else if (enable) begin
        last_temperature <= temperature; // Update last known temperature
        if (last_temperature > threshold) begin
            shutdown <= 1'b1; // Trigger shutdown if temperature exceeds threshold
        end else begin
            shutdown <= 1'b0; // Otherwise, do not shutdown
        end
    end
end

endmodule