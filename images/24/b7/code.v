module kalman_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] sensor_measurement,
    input wire [15:0] predicted_state,
    output reg [15:0] updated_state
);
    parameter K = 16'h0001; // Kalman gain (constant)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            updated_state <= 16'h0000; // Reset state
        end else begin
            updated_state <= predicted_state + K * (sensor_measurement - predicted_state);
        end
    end
endmodule