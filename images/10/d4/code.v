module KalmanFilter (  
    input clk,  
    input reset,  
    input [15:0] sensor1_pos,  
    input [15:0] sensor2_pos,  
    output reg [15:0] estimated_pos,  
    output reg [15:0] estimated_vel  
);  

    reg [15:0] x; // State vector (position, velocity)  
    reg [15:0] p; // Estimate error covariance  
    reg [15:0] q; // Process noise covariance  
    reg [15:0] r; // Measurement noise covariance  
    reg [15:0] k; // Kalman gain  

    initial begin  
        x = 0;  
        p = 16'hFFFF; // Large initial uncertainty  
        q = 16'h0001; // Process noise  
        r = 16'h0002; // Measurement noise  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x <= 0;  
            p <= 16'hFFFF;  
        end else begin  
            // Prediction step  
            x <= x; // Assuming constant velocity model for simplicity  
            p <= p + q;  

            // Measurement update step  
            k <= p / (p + r);  
            x <= x + k * (sensor1_pos + sensor2_pos)/2 - x;  
            p <= (1 - k) * p;  

            estimated_pos <= x;  
            estimated_vel <= (x - estimated_pos) / 2;  
        end  
    end  
endmodule