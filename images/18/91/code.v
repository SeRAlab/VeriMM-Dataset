module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement,
    input [15:0] process_noise,
    input [15:0] measurement_noise,
    output reg [15:0] estimate
);
    reg [15:0] estimate_prior;
    reg [15:0] uncertainty;
    reg [15:0] kalman_gain;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimate <= 16'h0;
            estimate_prior <= 16'h0;
            uncertainty <= 16'hFFFF; // Large initial uncertainty
        end else begin
            // Prediction Step
            estimate_prior <= estimate; // Prior estimate is the current estimate
            uncertainty <= uncertainty + process_noise; // Increase uncertainty by process noise

            // Measurement Update Step
            kalman_gain <= uncertainty / (uncertainty + measurement_noise); // Calculate Kalman Gain
            estimate <= estimate_prior + (kalman_gain * (measurement - estimate_prior)); // Update estimate
            uncertainty <= (16'hFFFF - kalman_gain) * uncertainty; // Update uncertainty
        end
    end
endmodule