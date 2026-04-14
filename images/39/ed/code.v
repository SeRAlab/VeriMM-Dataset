module PLL (  
    input wire clk_in,  
    input wire reset,  
    output reg clk_out,  
    output reg phase_error  
);  
    reg [7:0] phase_error_reg;  
    reg [7:0] vco_output;  
    reg [7:0] filter_output;  

    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            phase_error_reg <= 8'd0;  
            vco_output <= 8'd0;  
            clk_out <= 0;  
            phase_error <= 0;  
        end else begin  
            // Phase Detector: Simple phase error calculation  
            phase_error_reg <= phase_error_reg + (vco_output > 8'd128 ? 1 : -1);  
            phase_error <= phase_error_reg;  

            // Low-pass Filter: Simple averaging filter  
            filter_output <= (filter_output + phase_error_reg) >> 1;  

            // Voltage-Controlled Oscillator (VCO)  
            vco_output <= filter_output;  
            clk_out <= ~clk_out;  
        end  
    end  
endmodule