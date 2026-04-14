module pll(  
    input wire clk_in,  
    input wire ref_freq,  
    output reg clk_out  
);  
    reg [3:0] phase_accumulator;  
    reg [3:0] phase_error;  
    reg [3:0] phase_adjust;  

    always @(posedge clk_in) begin  
        phase_accumulator <= phase_accumulator + 1;  
        phase_error <= ref_freq - phase_accumulator;  
        phase_adjust <= phase_error >> 1;  
        clk_out <= clk_out + phase_adjust;  
    end  
endmodule