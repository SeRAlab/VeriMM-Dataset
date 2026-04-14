module pitch_detector(  
    input clk,  
    input reset,  
    input [15:0] frequency,  
    output reg pitch_level  
);  
    parameter THRESHOLD = 440;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            pitch_level <= 0;  
        else if (frequency > THRESHOLD)  
            pitch_level <= 1;  
        else  
            pitch_level <= 0;  
    end  
endmodule