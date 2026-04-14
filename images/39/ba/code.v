module dac_16bit (  
    input [15:0] binary_input,  
    output reg [15:0] analog_output  
);  
    parameter V_ref = 16'hFFFF; // Assuming 5V reference scaled for 16-bit  
    always @(*) begin  
        analog_output = (binary_input * V_ref) / 16'hFFFF;  
    end  
endmodule