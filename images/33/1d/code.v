module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement,
    input [15:0] previous_estimate,
    output reg [15:0] updated_estimate
);
    parameter K = 16'h000A; // Simplified Kalman gain

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_estimate <= 16'h0000; // Reset the estimate
        end else begin
            updated_estimate <= previous_estimate + (K * (measurement - previous_estimate) >> 4);
        end
    end
endmodule