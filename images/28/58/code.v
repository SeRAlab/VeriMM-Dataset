module kalman_filter #(parameter N = 32) (  
    input clk,  
    input reset,  
    input [N-1:0] z_position,  // Measured position  
    input [N-1:0] z_velocity,  // Measured velocity  
    output reg [N-1:0] x_position, // Estimated position  
    output reg [N-1:0] x_velocity  // Estimated velocity  
);  

    reg [N-1:0] P_position, P_velocity; // Error covariance  
    reg [N-1:0] K_position, K_velocity; // Kalman gain  
    reg [N-1:0] Q_position, Q_velocity; // Process noise covariance  
    reg [N-1:0] R_position, R_velocity; // Measurement noise covariance  

    initial begin  
        P_position = 32'h00000001; // Initial error covariance  
        P_velocity = 32'h00000001;  
        Q_position = 32'h00000001; // Process noise  
        Q_velocity = 32'h00000001;  
        R_position = 32'h00000010; // Measurement noise  
        R_velocity = 32'h00000010;  
        x_position = 32'h00000000; // Initial estimate  
        x_velocity = 32'h00000000;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x_position <= 32'h00000000;  
            x_velocity <= 32'h00000000;  
            P_position <= 32'h00000001;  
            P_velocity <= 32'h00000001;  
        end else begin  
            // Predict Step  
            x_position <= x_position; // Assuming constant position  
            x_velocity <= x_velocity; // Assuming constant velocity  
            P_position <= P_position + Q_position;  
            P_velocity <= P_velocity + Q_velocity;  

            // Update Step  
            K_position <= P_position / (P_position + R_position);  
            K_velocity <= P_velocity / (P_velocity + R_velocity);  

            x_position <= x_position + K_position * (z_position - x_position);  
            x_velocity <= x_velocity + K_velocity * (z_velocity - x_velocity);  

            P_position <= (32'h00000001 - K_position) * P_position;  
            P_velocity <= (32'h00000001 - K_velocity) * P_velocity;  
        end  
    end  
endmodule