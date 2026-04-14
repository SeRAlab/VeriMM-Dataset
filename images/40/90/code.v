module DAC_24_to_8 (  
    input [23:0] digital_input,  
    output reg [7:0] analog_output  
);  
    always @(*) begin  
        if (digital_input < 24'b000000000000000000000000)  
            analog_output = 8'b00000000;  
        else if (digital_input > 24'b111111111111111111111111)  
            analog_output = 8'b11111111;  
        else  
            analog_output = digital_input[23:16];  
    end  
endmodule