module kalman_filter (  
    input clk,  
    input rst,  
    input [15:0] z_position,  // Measurement from position sensor  
    input [15:0] z_velocity,  // Measurement from velocity sensor  
    output reg [15:0] x_position,  // Estimated position  
    output reg [15:0] x_velocity   // Estimated velocity  
);  

    // Kalman filter parameters  
    reg [15:0] P_position;  // Estimate error covariance for position  
    reg [15:0] P_velocity;  // Estimate error covariance for velocity  
    reg [15:0] K_position;  // Kalman gain for position  
    reg [15:0] K_velocity;  // Kalman gain for velocity  

    // Initial estimates  
    initial begin  
        x_position = 16'd0;  
        x_velocity = 16'd0;  
        P_position = 16'd1000;  // Initial estimate error  
        P_velocity = 16'd1000;  // Initial estimate error  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_position <= 16'd0;  
            x_velocity <= 16'd0;  
            P_position <= 16'd1000;  
            P_velocity <= 16'd1000;  
        end else begin  
            // Prediction step  
            x_position <= x_position + x_velocity;  
            P_position <= P_position + 16'd100; // Process noise  

            // Update step for position  
            K_position <= P_position / (P_position + 16'd10); // Measurement noise  
            x_position <= x_position + K_position * (z_position - x_position);  
            P_position <= (16'd1 - K_position) * P_position;  

            // Update step for velocity  
            K_velocity <= P_velocity / (P_velocity + 16'd10); // Measurement noise  
            x_velocity <= x_velocity + K_velocity * (z_velocity - x_velocity);  
            P_velocity <= (16'd1 - K_velocity) * P_velocity;  
        end  
    end  
endmodule