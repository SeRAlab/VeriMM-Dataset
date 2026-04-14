module kalman_filter (  
    input clk,  
    input rst,  
    input [15:0] z_pos,  // position measurement from sensor 1  
    input [15:0] z_vel,  // velocity measurement from sensor 2  
    output reg [15:0] x_hat_pos,  // estimated position  
    output reg [15:0] x_hat_vel   // estimated velocity  
);  
    reg [15:0] p_pos, p_vel;  // estimation error covariance  
    reg [15:0] k_pos, k_vel;  // Kalman gain  
    reg [15:0] q_pos, q_vel;  // process noise covariance  
    reg [15:0] r_pos, r_vel;  // measurement noise covariance  

    initial begin  
        p_pos = 16'h1;  
        p_vel = 16'h1;  
        q_pos = 16'h1;  
        q_vel = 16'h1;  
        r_pos = 16'h1;  
        r_vel = 16'h1;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_hat_pos <= 16'h0;  
            x_hat_vel <= 16'h0;  
            p_pos <= 16'h1;  
            p_vel <= 16'h1;  
        end else begin  
            // Prediction update  
            x_hat_pos <= x_hat_pos;  
            x_hat_vel <= x_hat_vel;  
            p_pos <= p_pos + q_pos;  
            p_vel <= p_vel + q_vel;  

            // Measurement update  
            k_pos <= p_pos / (p_pos + r_pos);  
            k_vel <= p_vel / (p_vel + r_vel);  
            x_hat_pos <= x_hat_pos + k_pos * (z_pos - x_hat_pos);  
            x_hat_vel <= x_hat_vel + k_vel * (z_vel - x_hat_vel);  
            p_pos <= (16'hFFFF - k_pos) * p_pos;  
            p_vel <= (16'hFFFF - k_vel) * p_vel;  
        end  
    end  
endmodule