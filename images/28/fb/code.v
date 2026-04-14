module zero_crossing_detector(  
    input clk,  
    input signal,  
    output reg zero_cross  
);  
    reg previous_signal;  

    always @(posedge clk) begin  
        if (previous_signal == 1'b0 && signal == 1'b1)  
            zero_cross <= 1'b1; // Positive zero-crossing  
        else if (previous_signal == 1'b1 && signal == 1'b0)  
            zero_cross <= 1'b1; // Negative zero-crossing  
        else  
            zero_cross <= 1'b0; // No zero-crossing  
        
        previous_signal <= signal;  
    end  
endmodule