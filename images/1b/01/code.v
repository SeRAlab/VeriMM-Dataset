module kalman_filter (  
    input clk,  
    input rst,  
    input [15:0] z1, // Measurement from Sensor 1  
    input [15:0] z2, // Measurement from Sensor 2  
    input [15:0] u,  // Control input  
    output reg [15:0] x_est, // Estimated state output  
    output reg [15:0] p_est   // Estimated covariance output  
);  
    // Kalman filter parameters  
    reg [15:0] x_pred; // Predicted state  
    reg [15:0] p_pred; // Predicted covariance  
    reg [15:0] k;      // Kalman gain  
    reg [15:0] r;      // Measurement noise covariance  
    reg [15:0] q;      // Process noise covariance  

    initial begin  
        r = 16'h0001; // Example value for measurement noise  
        q = 16'h0001; // Example value for process noise  
        x_est = 16'h0000;  
        p_est = 16'h0001;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_est <= 16'h0000;  
            p_est <= 16'h0001;  
        end else begin  
            // Prediction step  
            x_pred <= x_est + u;  
            p_pred <= p_est + q;  
            // Update step  
            k <= p_pred / (p_pred + r);  
            x_est <= x_pred + k * (z1 + z2 - x_pred);  
            p_est <= (16'hFFFF - k) * p_pred;  
        end  
    end  
endmodule