module adc_8_to_4 (  
    input [7:0] adc_input,  
    output [3:0] adc_output  
);  
    assign adc_output = adc_input[7:4];  
endmodule