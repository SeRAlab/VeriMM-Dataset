module DVFS_Controller(  
    input wire [2:0] voltage_level, // 3-bit input for voltage levels  
    input wire frequency_control, // frequency control signal  
    output reg clock_enable // output clock enable signal  
);  
    always @(voltage_level or frequency_control) begin  
        if (voltage_level >= 3'b010 && frequency_control) // Check voltage and frequency signals  
            clock_enable <= 1'b1; // Enable clock  
        else  
            clock_enable <= 1'b0; // Disable clock  
    end  
endmodule