module pll(input clk_in,  
           output reg clk_out);  

    reg [1:0] phase_detector;  
    reg vco;  
    reg [3:0] lp_filter;  

    always @(posedge clk_in) begin  
        // Phase Detector Logic  
        if (vco == 1) begin  
            phase_detector <= 2'b01; // Phase aligned  
        end else begin  
            phase_detector <= 2'b10; // Phase not aligned  
        end  

        // Low-pass Filter Logic  
        lp_filter <= (lp_filter + phase_detector) >> 1;  

        // Voltage-Controlled Oscillator Logic  
        vco <= (lp_filter[0] == 1) ? ~vco : vco;  
        clk_out <= vco;  
    end  
endmodule