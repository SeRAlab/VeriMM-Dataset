module temperature_shutdown(
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 8'd75; // Temperature threshold
    parameter CYCLE_COUNT = 4; // Number of cycles to wait after temperature is below threshold

    reg [1:0] count; // Counter for cycles below threshold
    reg is_over_threshold; // Flag to indicate if temperature exceeded threshold

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 0;
            count <= 0;
            is_over_threshold <= 0;
        end else begin
            if (temperature > THRESHOLD) begin
                shutdown <= 1;
                is_over_threshold <= 1;
                count <= 0; // Reset count when temperature exceeds threshold
            end else if (is_over_threshold) begin
                if (count < CYCLE_COUNT - 1) begin
                    count <= count + 1; // Increment count when under threshold
                end else begin
                    shutdown <= 0; // Deactivate shutdown after counting cycles
                    is_over_threshold <= 0; // Reset flag
                end
            end
        end
    end
endmodule