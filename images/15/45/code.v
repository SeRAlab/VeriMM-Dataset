module DAC_24bit (  
    input [23:0] binary_input,  
    input [15:0] V_ref, // Reference voltage in millivolts  
    output reg [15:0] analog_output // Output analog voltage in millivolts  
);  
    always @(*) begin  
        analog_output = (V_ref * binary_input) / 24'hFFFFFF;  
    end  
endmodule