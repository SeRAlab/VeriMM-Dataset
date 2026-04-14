module pitch_detector(  
    input clock,  
    input reset,  
    input [7:0] signal_in,  
    input [7:0] threshold,  
    output reg detected  
);  

always @(posedge clock or posedge reset) begin  
    if (reset) begin  
        detected <= 0;  
    end else begin  
        if (signal_in > threshold)  
            detected <= 1;  
        else  
            detected <= 0;  
    end  
end  
endmodule