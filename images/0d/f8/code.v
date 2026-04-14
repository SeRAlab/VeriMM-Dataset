module KalmanFilter (
    input wire clk,
    input wire reset,
    input wire [31:0] sensor1_measurement,
    input wire [31:0] sensor1_uncertainty,
    input wire [31:0] sensor2_measurement,
    input wire [31:0] sensor2_uncertainty,
    output reg [31:0] fused_measurement,
    output reg [31:0] fused_uncertainty
);
    reg [31:0] x_k, P_k, K_k, Q, R;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_k <= 32'b0;
            P_k <= 32'b1; // Initial estimate covariance
            fused_measurement <= 32'b0;
            fused_uncertainty <= 32'b1; // Initial uncertainty
        end else begin
            // Prediction Step
            x_k <= x_k; // Assuming no control input u for simplicity
            P_k <= P_k + Q; // Q is assumed to be zero for simplicity
            
            // Update Step
            R <= (sensor1_uncertainty + sensor2_uncertainty) >> 1; // Average uncertainty
            K_k <= P_k / (P_k + R);
            fused_measurement <= x_k + K_k * (sensor1_measurement + sensor2_measurement - 2 * x_k);
            fused_uncertainty <= (32'b1 - K_k) * P_k;
        end
    end
endmodule