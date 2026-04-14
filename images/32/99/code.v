module temp_shutdown(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,  // 8-bit temperature input
    output reg shutdown            // shutdown signal output
);

    parameter THRESHOLD = 8'd75;   // Temperature threshold for shutdown

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;          // Clear the shutdown state
        end else if (temperature > THRESHOLD) begin
            shutdown <= 1;          // Activate shutdown
        end else begin
            shutdown <= 0;          // Deactivate shutdown if below threshold
        end
    end

endmodule