module phase_detector(  
    input clk,  
    input reset,  
    input phase_a,  
    input phase_b,  
    output reg signed [1:0] phase_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        phase_out <= 0;  
    end else begin  
        if (phase_a == phase_b)  
            phase_out <= 0; // In phase  
        else if (phase_a > phase_b)  
            phase_out <= 1; // phase_a leads  
        else  
            phase_out <= -1; // phase_a lags  
    end  
end  
endmodule