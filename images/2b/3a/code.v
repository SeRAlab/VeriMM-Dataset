module temp_shutdown (
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 8'd75; // Temperature threshold

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 1'b0; // Reset shutdown state
        end else if (temperature > THRESHOLD) begin
            shutdown <= 1'b1; // Activate shutdown if temperature exceeds threshold
        end else begin
            shutdown <= 1'b0; // Deactivate shutdown if temperature is within limits
        end
    end
endmodule