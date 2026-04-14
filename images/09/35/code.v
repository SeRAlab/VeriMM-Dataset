module temp_shutdown_controller(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature, // 8-bit temperature input
    input wire [7:0] threshold,    // 8-bit threshold input
    output reg shutdown            // Shutdown signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 1'b0; // Reset shutdown signal
        end else begin
            if (temperature > threshold) begin
                shutdown <= 1'b1; // Trigger shutdown
            end else begin
                shutdown <= 1'b0; // Normal operation
            end
        end
    end
endmodule