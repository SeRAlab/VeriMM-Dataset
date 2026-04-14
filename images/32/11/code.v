module kalman_filter(  
    input clk,  
    input rst,  
    input [15:0] measurement,  
    output reg [15:0] estimate  
);  
    reg [15:0] q = 16'h000A; // Process noise covariance  
    reg [15:0] r = 16'h0050; // Measurement noise covariance  
    reg [15:0] k; // Kalman gain  
    reg [15:0] p = 16'h0001; // Estimate error covariance  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            estimate <= 16'h0000;  
            p <= 16'h0001;  
        end else begin  
            // Kalman gain  
            k <= p / (p + r);  
            // Update estimate  
            estimate <= estimate + k * (measurement - estimate);  
            // Update error covariance  
            p <= (16'hFFFF - k) * p + q;  
        end  
    end  
endmodule