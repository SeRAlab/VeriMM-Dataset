module temp_shutdown (
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 8'd75; // Temperature threshold for shutdown

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 0; // Clear shutdown signal on reset
        end else begin
            if (temperature > THRESHOLD) begin
                shutdown <= 1; // Activate shutdown if temperature exceeds threshold
            end else begin
                shutdown <= 0; // Deactivate shutdown otherwise
            end
        end
    end
endmodule