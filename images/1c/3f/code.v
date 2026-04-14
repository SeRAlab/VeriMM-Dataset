module adc_16_to_5(  
    input [15:0] adc_input,  
    output reg [4:0] adc_output  
);  
    always @(*) begin  
        if (adc_input > 31 * 2048)  
            adc_output = 5'b11111; // Cap at 31  
        else  
            adc_output = adc_input / 2048;  
    end  
endmodule