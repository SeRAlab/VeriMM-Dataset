module kalman_filter (
    input clk,
    input reset,
    input [15:0] prev_state,
    input [15:0] control_input,
    input [15:0] measurement,
    input [15:0] measurement_noise,
    input [15:0] process_noise,
    output reg [15:0] updated_state
);
    reg [15:0] predicted_state;
    reg [15:0] kalman_gain;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            updated_state <= 16'b0;
            predicted_state <= 16'b0;
            kalman_gain <= 16'b0;
        end else begin
            // Prediction step
            predicted_state <= prev_state + control_input;

            // Calculate Kalman Gain
            kalman_gain <= predicted_state / (predicted_state + measurement_noise);

            // Update step
            updated_state <= predicted_state + kalman_gain * (measurement - predicted_state);
        end
    end
endmodule