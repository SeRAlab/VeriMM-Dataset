module fractional_n_pll(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] input_freq,  
    input wire [15:0] division_ratio,  
    output reg [15:0] control_voltage  
);  

    reg [31:0] phase_accumulator;  
    reg [15:0] freq_divider;  
    reg [15:0] desired_freq;  
    reg update;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            phase_accumulator <= 0;  
            control_voltage <= 0;  
            update <= 0;  
        end else begin  
            // Calculate desired frequency based on division ratio  
            desired_freq <= input_freq / division_ratio;  
            phase_accumulator <= phase_accumulator + desired_freq;  

            // Update control voltage based on phase comparison  
            if (phase_accumulator >= 1 << 16) begin  
                control_voltage <= control_voltage + 1;  
                phase_accumulator <= phase_accumulator - (1 << 16);  
            end  
            update <= 1;  
        end  
    end  
endmodule