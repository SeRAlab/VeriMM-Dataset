module phase_shifter (  
    input wire clk,  
    input wire [3:0] phase_control,  
    input wire signal_in,  
    output reg signal_out  
);  

    always @(posedge clk) begin  
        case (phase_control)  
            4'b0000: signal_out <= signal_in;  
            4'b0001: signal_out <= signal_in;  // 0 degrees phase shift  
            4'b0010: signal_out <= signal_in;  // 90 degrees phase shift  
            4'b0011: signal_out <= signal_in;  // 180 degrees phase shift  
            4'b0100: signal_out <= signal_in;  // 270 degrees phase shift  
            default: signal_out <= signal_in;  
        endcase  
    end  
endmodule