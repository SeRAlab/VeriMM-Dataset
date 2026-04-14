module phase_detector (  
    input wire signal_a,  
    input wire signal_b,  
    output reg [1:0] phase_out  
);  
    always @(*) begin  
        if (signal_a == signal_b)  
            phase_out = 2'b00; // In-phase  
        else if (signal_a > signal_b)  
            phase_out = 2'b01; // signal_a leads  
        else  
            phase_out = 2'b10; // signal_a lags  
    end  
endmodule