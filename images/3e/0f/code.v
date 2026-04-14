module vco (  
    input clk,  
    input [2:0] control_voltage, // 3-bit control voltage input  
    output reg vco_output // VCO output signal  
);  
    reg [23:0] counter;  
    parameter BASE_FREQUENCY = 1000; // Base frequency in Hz for control_voltage = 0  
    parameter FREQUENCY_STEP = 500; // Frequency increment per control_voltage level  

    always @(posedge clk) begin  
        // Calculate frequency based on control_voltage  
        counter <= counter + 1;  
        if (counter >= (BASE_FREQUENCY + control_voltage * FREQUENCY_STEP)) begin  
            vco_output <= ~vco_output; // Toggle output  
            counter <= 0;  
        end  
    end  
endmodule