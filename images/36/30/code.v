module DAC_16bit (  
    input [15:0] digital_input,  
    input [15:0] V_ref,  
    output reg [15:0] analog_output  
);  
    always @(*) begin  
        analog_output = (digital_input * V_ref) >> 16; // V_ref is scaled down by a factor of 65536  
    end  
endmodule