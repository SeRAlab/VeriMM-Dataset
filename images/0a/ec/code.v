module adc_16_to_4 (  
    input [15:0] adc_input,  
    output reg [3:0] adc_output  
);  
    always @* begin  
        if (adc_input < 16)  
            adc_output = adc_input[3:0];  
        else if (adc_input < 32)  
            adc_output = 4'b0001;  
        else if (adc_input < 48)  
            adc_output = 4'b0010;  
        else if (adc_input < 64)  
            adc_output = 4'b0011;  
        else if (adc_input < 80)  
            adc_output = 4'b0100;  
        else if (adc_input < 96)  
            adc_output = 4'b0101;  
        else if (adc_input < 112)  
            adc_output = 4'b0110;  
        else if (adc_input < 128)  
            adc_output = 4'b0111;  
        else if (adc_input < 144)  
            adc_output = 4'b1000;  
        else if (adc_input < 160)  
            adc_output = 4'b1001;  
        else if (adc_input < 176)  
            adc_output = 4'b1010;  
        else if (adc_input < 192)  
            adc_output = 4'b1011;  
        else if (adc_input < 208)  
            adc_output = 4'b1100;  
        else if (adc_input < 224)  
            adc_output = 4'b1101;  
        else if (adc_input < 240)  
            adc_output = 4'b1110;  
        else  
            adc_output = 4'b1111;  
    end  
endmodule