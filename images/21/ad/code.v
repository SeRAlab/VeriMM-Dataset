module kalman_filter (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] measurement,  
    input wire [15:0] estimated_state,  
    output reg [15:0] updated_state  
);  
    // Kalman gain (for simplicity, fixed values are used)  
    parameter K = 16'h0001;  // Kalman gain  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            updated_state <= 16'h0000;  
        end else begin  
            // Kalman filter update equation  
            updated_state <= estimated_state + K * (measurement - estimated_state);  
        end  
    end  
endmodule