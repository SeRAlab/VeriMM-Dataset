module pitch_detection(  
    input clk,  
    input reset,  
    input [3:0] frequency,  
    output reg signal  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            signal <= 0;  
        else if (frequency >= 4'b1000 && frequency <= 4'b1100)  
            signal <= 1;  
        else  
            signal <= 0;  
    end  
endmodule