module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement1,  
    input [15:0] measurement2,  
    input [15:0] uncertainty1,  
    input [15:0] uncertainty2,  
    output reg [15:0] fused_position  
);  

    reg [31:0] K; // Kalman gain  
    reg [31:0] P; // Estimate uncertainty  
    reg [31:0] x; // Fused estimate  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x <= 0;  
            P <= 1;  
            fused_position <= 0;  
        end else begin  
            K <= P / (P + uncertainty1 + uncertainty2);  
            x <= x + K * (measurement1 + measurement2 - x);  
            P <= (1 - K) * P;  
            fused_position <= x[15:0];  
        end  
    end  
endmodule