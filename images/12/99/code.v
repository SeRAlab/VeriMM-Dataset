module phase_detector (  
    input clk,  
    input signal_a,  
    input signal_b,  
    output reg phase_diff  
);  
    always @(posedge clk) begin  
        if (signal_a && !signal_b) begin  
            phase_diff <= 1; // Signal A leads Signal B  
        end else if (!signal_a && signal_b) begin  
            phase_diff <= 0; // Signal B leads Signal A  
        end else begin  
            phase_diff <= phase_diff; // No change  
        end  
    end  
endmodule