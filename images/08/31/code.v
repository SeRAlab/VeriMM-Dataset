module kalman_filter(  
    input wire clk,  
    input wire rst,  
    input wire [15:0] measurement1,  
    input wire [15:0] measurement2,  
    output reg [15:0] position_estimate,  
    output reg [15:0] velocity_estimate  
);  

    reg [15:0] state_estimate;  
    reg [15:0] uncertainty;  
    reg [15:0] kalman_gain;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            position_estimate <= 16'd0;  
            velocity_estimate <= 16'd0;  
            state_estimate <= 16'd0;  
            uncertainty <= 16'd1000;  // Initial uncertainty  
        end else begin  
            // Predict Step  
            state_estimate <= state_estimate + velocity_estimate;  
            uncertainty <= uncertainty + 16'd10;  // Process noise  

            // Update Step  
            kalman_gain <= uncertainty / (uncertainty + 16'd100);  // Measurement noise  
            position_estimate <= state_estimate + kalman_gain * (measurement1 + measurement2 - state_estimate);  
            velocity_estimate <= velocity_estimate + kalman_gain * (measurement1 + measurement2 - state_estimate);  

            // Update uncertainty  
            uncertainty <= (16'd1 - kalman_gain) * uncertainty;  
        end  
    end  
endmodule