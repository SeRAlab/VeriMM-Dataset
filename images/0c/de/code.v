module FractionalN_PLL (  
    input clk,  
    input reset,  
    input [3:0] control_signal, // Control signal for division ratio  
    input [15:0] input_freq, // Input frequency  
    output reg [15:0] output_freq // Output frequency  
);  
    reg [3:0] division_ratio;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            division_ratio <= 4'b0001; // Default division ratio  
            output_freq <= 0;  
        end else begin  
            division_ratio <= control_signal;  
            output_freq <= input_freq / division_ratio;  
        end  
    end  
endmodule