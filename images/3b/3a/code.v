module zero_crossing_detector(  
    input clk,  
    input reset,  
    input signal_in,  
    output reg pulse_out  
);  
    reg signal_prev;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            signal_prev <= 0;  
            pulse_out <= 0;  
        end else begin  
            if (signal_prev == 0 && signal_in == 1) begin  
                pulse_out <= 1;  
            end else begin  
                pulse_out <= 0;  
            end  
            signal_prev <= signal_in;  
        end  
    end  
endmodule