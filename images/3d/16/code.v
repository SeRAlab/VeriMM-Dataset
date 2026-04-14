module kalman_filter #(parameter STATE_WIDTH = 16, parameter MEASUREMENT_WIDTH = 16)  
(  
    input clk,  
    input reset,  
    input [MEASUREMENT_WIDTH-1:0] measurement,  
    input [STATE_WIDTH-1:0] control,  
    output reg [STATE_WIDTH-1:0] state_estimate  
);  
    reg [STATE_WIDTH-1:0] prev_state;  
    reg [STATE_WIDTH-1:0] kalman_gain;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state_estimate <= 0;  
            prev_state <= 0;  
            kalman_gain <= 16'h1; // Simplified constant gain  
        end else begin  
            // Predict state  
            prev_state <= state_estimate + control;  
            // Update state with measurement  
            state_estimate <= prev_state + (kalman_gain * (measurement - prev_state));  
        end  
    end  
endmodule