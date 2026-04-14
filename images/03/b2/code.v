module digital_phase_shifter(  
    input clk,  
    input [1:0] phase_control,  
    input signal_in,  
    output reg signal_out  
);  

    always @(posedge clk) begin  
        case (phase_control)  
            2'b00: signal_out <= signal_in;        // 0 degrees  
            2'b01: signal_out <= ~signal_in;       // 90 degrees (inverted)  
            2'b10: signal_out <= signal_in;        // 180 degrees (can be implemented with delay)  
            2'b11: signal_out <= ~signal_in;       // 270 degrees (inverted)  
            default: signal_out <= signal_in;      // Default to 0 degrees  
        endcase  
    end  
endmodule