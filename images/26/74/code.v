module temperature_shutdown (
    input wire clk,
    input wire reset,
    input wire [3:0] temperature, // 4-bit temperature input
    output reg shutdown // Shutdown signal output
);
    parameter THRESHOLD = 4'd10; // Define the temperature threshold

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 1'b0; // Reset the shutdown signal
        end else if (temperature > THRESHOLD) begin
            shutdown <= 1'b1; // Activate shutdown if temperature exceeds threshold
        end else begin
            shutdown <= 1'b0; // Deactivate shutdown if temperature is normal
        end
    end
endmodule