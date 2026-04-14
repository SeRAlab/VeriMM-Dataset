module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    output reg [15:0] estimate  
);  
    reg [15:0] q; // process noise covariance  
    reg [15:0] r; // measurement noise covariance  
    reg [15:0] k; // Kalman gain  

    initial begin  
        estimate = 0;  
        q = 16'h0001;  
        r = 16'h0002;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate <= 0;  
        end else begin  
            // Update Kalman gain  
            k <= (estimate + q) / (estimate + q + r);  
            // Update estimate  
            estimate <= estimate + k * (measurement - estimate);  
        end  
    end  
endmodule