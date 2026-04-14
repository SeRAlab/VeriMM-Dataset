module hazard_detection(  
    input [3:0] control_signal,  
    output reg hazard  
);  
    always @(*) begin  
        hazard = 0;  
        if ((control_signal[0] ^ control_signal[1]) && (control_signal[1] ^ control_signal[2]) ||  
            (control_signal[1] ^ control_signal[2]) && (control_signal[2] ^ control_signal[3]) ||  
            (control_signal[0] ^ control_signal[1]) && (control_signal[2] ^ control_signal[3])) begin  
            hazard = 1;  
        end  
    end  
endmodule