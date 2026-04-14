module zero_crossing_detector (  
    input wire clk,  
    input wire reset,  
    input wire signal_in,  
    output reg zero_cross_detected  
);  
    reg signal_prev;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            zero_cross_detected <= 0;  
            signal_prev <= 0;  
        end else begin  
            zero_cross_detected <= (signal_prev == 0 && signal_in == 1);  
            signal_prev <= signal_in;  
        end  
    end  
endmodule