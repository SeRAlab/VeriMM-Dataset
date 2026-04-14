module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    input [15:0] current_estimate,  
    input [15:0] kalman_gain,  
    output reg [15:0] updated_estimate  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            updated_estimate <= 16'b0;  
        end else begin  
            updated_estimate <= current_estimate + (kalman_gain * (measurement - current_estimate));  
        end  
    end  
endmodule