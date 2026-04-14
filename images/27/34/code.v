module adc_decoder(  
    input [15:0] adc_input,  
    output [15:0] decimal_output  
);  
    assign decimal_output = adc_input;  
endmodule