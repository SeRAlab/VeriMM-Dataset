module pitch_detector(  
    input clk,  
    input reset,  
    input [7:0] signal_in,  
    input [7:0] threshold,  
    output reg is_high_pitch  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            is_high_pitch <= 0;  
        end else begin  
            if (signal_in > threshold)  
                is_high_pitch <= 1;  
            else  
                is_high_pitch <= 0;  
        end  
    end  
endmodule