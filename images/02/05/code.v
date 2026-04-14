module KalmanFilter(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] sensor1,  
    input wire [15:0] sensor2,  
    output reg [15:0] estimate,  
    output reg [15:0] P  
);  
    reg [15:0] K; // Kalman gain  
    reg [15:0] R; // Measurement noise covariance  
    reg [15:0] Q; // Process noise covariance  

    initial begin  
        estimate = 0;  
        P = 16'hFFFF;  
        K = 0;  
        R = 16'h00FF;  
        Q = 16'h0001;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate <= 0;  
            P <= 16'hFFFF;  
        end else begin  
            // Prediction step  
            P <= P + Q;  
            // Update step  
            K <= P / (P + R);  
            estimate <= estimate + K * (sensor1 + sensor2 - estimate);  
            // Update error covariance  
            P <= (16'hFFFF - K) * P;  
        end  
    end  
endmodule