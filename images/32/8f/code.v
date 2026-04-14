module adc_4to8 (  
    input [3:0] binary_in,  
    output [7:0] adc_out  
);  
    assign adc_out = binary_in * 16;  
endmodule