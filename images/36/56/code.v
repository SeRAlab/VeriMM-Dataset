module kalman_filter #(parameter DT = 1, K = 1, K_V = 1) (  
    input clk,  
    input reset,  
    input [15:0] z,      // Measured position  
    input [15:0] z_v,    // Control input for velocity  
    output reg [15:0] x_est,  // Estimated position  
    output reg [15:0] v_est   // Estimated velocity  
);  
    reg [15:0] x_prev;  
    reg [15:0] v_prev;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x_prev <= 16'd0;  
            v_prev <= 16'd0;  
            x_est <= 16'd0;  
            v_est <= 16'd0;  
        end else begin  
            // Prediction step  
            x_prev <= x_est + (v_est * DT);  
            v_prev <= v_est;  
            
            // Update step  
            x_est <= x_prev + (K * (z - x_prev));  
            v_est <= v_prev + (K_V * (z_v - v_prev));  
        end  
    end  
endmodule