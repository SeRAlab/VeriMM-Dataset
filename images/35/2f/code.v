module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measured_position,  
    input [15:0] measured_velocity,  
    output reg [15:0] estimated_position,  
    output reg [15:0] estimated_velocity  
);  

    // Kalman filter parameters  
    reg [15:0] K_position;  
    reg [15:0] K_velocity;  
    reg [15:0] P_position;  
    reg [15:0] P_velocity;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimated_position <= 0;  
            estimated_velocity <= 0;  
            K_position <= 16'h1;  
            K_velocity <= 16'h1;  
            P_position <= 16'h1;  
            P_velocity <= 16'h1;  
        end else begin  
            // Prediction step (for simplicity, we assume a constant velocity model)  
            estimated_position <= estimated_position + estimated_velocity;  
            estimated_velocity <= estimated_velocity;  

            // Update step  
            K_position <= P_position / (P_position + 16'h1);  
            K_velocity <= P_velocity / (P_velocity + 16'h1);  

            estimated_position <= estimated_position + K_position * (measured_position - estimated_position);  
            estimated_velocity <= estimated_velocity + K_velocity * (measured_velocity - estimated_velocity);  

            // Update the error covariance  
            P_position <= (16'h1 - K_position) * P_position;  
            P_velocity <= (16'h1 - K_velocity) * P_velocity;  
        end  
    end  
endmodule