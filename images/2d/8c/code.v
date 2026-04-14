module kalman_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] measurement,
    output reg [15:0] position_estimate,
    output reg [15:0] velocity_estimate
);
    reg [15:0] estimation_error;
    reg [15:0] kalman_gain;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position_estimate <= 16'd0;
            velocity_estimate <= 16'd0;
            estimation_error <= 16'd1;
        end else begin
            // Prediction step
            position_estimate <= position_estimate + velocity_estimate;
            estimation_error <= estimation_error + 16'd1; // increase error
            
            // Update step
            kalman_gain <= estimation_error / (estimation_error + 16'd1); // measurement noise
            position_estimate <= position_estimate + kalman_gain * (measurement - position_estimate);
            estimation_error <= (16'd1 - kalman_gain) * estimation_error;
        end
    end
endmodule