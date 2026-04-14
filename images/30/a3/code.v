module adc_top_msb (  
    input [15:0] adc_input,  
    output [4:0] adc_output  
);  
    assign adc_output = adc_input[15:11];  
endmodule