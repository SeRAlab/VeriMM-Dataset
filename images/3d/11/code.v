module DAC_24_to_8 (  
    input [23:0] digital_input,  
    input [3:0] scaling_factor,  
    output reg [7:0] analog_output  
);  
    always @(*) begin  
        // Scale the digital input by the scaling factor  
        analog_output = (digital_input >> (24 - scaling_factor)) & 8'hFF;  
        // Clamp the output to 255 if it exceeds  
        if (analog_output > 8'hFF)  
            analog_output = 8'hFF;  
    end  
endmodule