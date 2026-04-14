module kalman_filter (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] position_meas,  
    input wire [15:0] velocity_meas,  
    output reg [15:0] position_est,  
    output reg [15:0] velocity_est  
);  

    reg [15:0] position_cov;  
    reg [15:0] velocity_cov;  
    reg [15:0] kalman_gain;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            position_est <= 16'h0;  
            velocity_est <= 16'h0;  
            position_cov <= 16'hFFFF;  
            velocity_cov <= 16'hFFFF;  
        end else begin  
            // Prediction Step  
            position_est <= position_est + velocity_est;  
            velocity_est <= velocity_est;  

            // Update Step  
            kalman_gain <= position_cov / (position_cov + 16'hFF);  
            position_est <= position_est + kalman_gain * (position_meas - position_est);  
            velocity_est <= velocity_est + kalman_gain * (velocity_meas - velocity_est);  

            // Update Covariance  
            position_cov <= (16'hFFFF - kalman_gain) * position_cov;  
            velocity_cov <= (16'hFFFF - kalman_gain) * velocity_cov;  
        end  
    end  
endmodule