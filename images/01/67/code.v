module temp_shutdown_system(
    input clk,
    input reset,
    input [7:0] temperature,
    input [7:0] threshold,
    output reg shutdown
);
    reg state; // 0 = Normal, 1 = Shutdown

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0; // Reset state to Normal
            shutdown <= 0; // No shutdown
        end else begin
            if (temperature > threshold) begin
                state <= 1; // Switch to Shutdown state
                shutdown <= 1; // Trigger shutdown
            end else if (state == 1 && temperature <= threshold) begin
                state <= 0; // Switch back to Normal state
                shutdown <= 0; // End shutdown
            end
        end
    end
endmodule