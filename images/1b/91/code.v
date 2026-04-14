module ADC_Interface (  
    input [7:0] analog_input,  
    output [15:0] digital_output  
);  
    assign digital_output = {8'b00000000, analog_input};  
endmodule