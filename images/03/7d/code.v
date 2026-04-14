module adc_8bit(  
    input [9:0] analog_input,  
    output [7:0] digital_output  
);  
    assign digital_output = analog_input[9:2]; // Taking the most significant 8 bits  
endmodule