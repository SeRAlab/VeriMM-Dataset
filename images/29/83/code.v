module temp_shutdown(
    input clk,
    input reset,
    input enable,
    input [7:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 8'd75; // Shutdown threshold
    parameter SAFE_TEMP = 8'd70; // Safe temperature for reset

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else if (enable) begin
            if (temperature > THRESHOLD) begin
                shutdown <= 1; // Trigger shutdown
            end else if (temperature < SAFE_TEMP) begin
                shutdown <= 0; // Reset shutdown
            end
        end
    end
endmodule