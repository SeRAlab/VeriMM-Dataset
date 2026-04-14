module kalman_filter (input clk,  
                      input rst,  
                      input signed [15:0] sensor1,  
                      input signed [15:0] sensor2,  
                      output reg signed [15:0] estimated_position);  

    // Constants for Kalman filter  
    parameter signed [15:0] Q = 16'h0001;  // Process noise covariance  
    parameter signed [15:0] R = 16'h0004;  // Measurement noise covariance  
    parameter signed [15:0] K = 16'h0002;  // Kalman gain  

    reg signed [15:0] x; // Estimated state  
    reg signed [15:0] p; // Estimate error covariance  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x <= 16'h0000;  
            p <= 16'h0001;  
            estimated_position <= 16'h0000;  
        end else begin  
            // Predict phase  
            p <= p + Q;  
            
            // Update phase  
            estimated_position <= x;  
            x <= x + K * (sensor1 + sensor2)/2 - x;  
            p <= (1 - K) * p;  
        end  
    end  
endmodule