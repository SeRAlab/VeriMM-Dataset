module temperature_shutdown(
    input clk,
    input reset,
    input [7:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 8'd100; // Temperature threshold for shutdown
    parameter SAFE_TEMP = 8'd80;   // Safe temperature to reset shutdown

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else begin
            if (temperature > THRESHOLD) begin
                shutdown <= 1; // Activate shutdown
            end else if (temperature < SAFE_TEMP) begin
                shutdown <= 0; // Deactivate shutdown
            end
        end
    end
endmodule