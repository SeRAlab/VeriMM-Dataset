module echo_cancellation(  
    input clk,  
    input rst,  
    input [15:0] input_signal,  
    input [15:0] reference_signal,  
    output reg [15:0] output_signal  
);  
    reg [15:0] scaled_reference;  
    parameter scaling_factor = 16'h0004;  // Example scaling factor  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_signal <= 16'h0000;  
        end else begin  
            scaled_reference <= reference_signal * scaling_factor;  
            output_signal <= input_signal - scaled_reference;  
        end  
    end  
endmodule