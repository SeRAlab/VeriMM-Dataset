module pitch_detection(  
    input clk,  
    input rst,  
    input [9:0] frequency,  
    input [9:0] threshold,  
    output reg pitch_detected  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            pitch_detected <= 0;  
        else  
            pitch_detected <= (frequency > threshold) ? 1 : 0;  
    end  
endmodule