module zero_crossing_detector(  
    input clk,  
    input reset,  
    input signal_in,  
    output reg zero_cross_detected  
);  
    reg signal_in_d;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            zero_cross_detected <= 0;  
            signal_in_d <= 0;  
        end else begin  
            zero_cross_detected <= (signal_in_d ^ signal_in); // Detects change in signal  
            signal_in_d <= signal_in;  
        end  
    end  
endmodule