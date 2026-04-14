module PLL(input clk, input reset, input [7:0] frequency_in, output reg [7:0] frequency_out);  
    reg [7:0] frequency_estimate;  
    reg [7:0] phase_error;  
    reg [7:0] phase_adjust;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frequency_out <= 8'b0;  
            frequency_estimate <= 8'b0;  
        end else begin  
            phase_error <= frequency_in - frequency_estimate;  
            phase_adjust <= phase_error >> 1; // simple proportional control  
            frequency_estimate <= frequency_estimate + phase_adjust;  
            frequency_out <= frequency_estimate;  
        end  
    end  
endmodule