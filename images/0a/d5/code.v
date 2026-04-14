module adc_to_gray_converter(  
    input [23:0] binary_input,  
    output [23:0] gray_output  
);  
    assign gray_output = binary_input ^ (binary_input >> 1);  
endmodule