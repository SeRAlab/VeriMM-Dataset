module kalman_filter(input clk,  
                     input reset,  
                     input [15:0] measurement_x,  
                     input [15:0] measurement_y,  
                     output reg [15:0] estimate_x,  
                     output reg [15:0] estimate_y,  
                     output reg [15:0] velocity_x,  
                     output reg [15:0] velocity_y);  

    // State variables for position and velocity estimation  
    reg [15:0] x_hat;  
    reg [15:0] y_hat;  
    reg [15:0] v_x;  
    reg [15:0] v_y;  

    // Kalman gain (for simplicity, fixed values are used)
    parameter K_x = 16'h0005;  
    parameter K_y = 16'h0005;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x_hat <= 16'h0000;  
            y_hat <= 16'h0000;  
            v_x <= 16'h0000;  
            v_y <= 16'h0000;  
        end else begin  
            // Prediction step  
            x_hat <= x_hat + v_x;  
            y_hat <= y_hat + v_y;  

            // Update step  
            v_x <= v_x + K_x * (measurement_x - x_hat);  
            v_y <= v_y + K_y * (measurement_y - y_hat);  
            x_hat <= x_hat + K_x * (measurement_x - x_hat);  
            y_hat <= y_hat + K_y * (measurement_y - y_hat);  
        end  
    end  

    always @(posedge clk) begin  
        estimate_x <= x_hat;  
        estimate_y <= y_hat;  
        velocity_x <= v_x;  
        velocity_y <= v_y;  
    end  
endmodule