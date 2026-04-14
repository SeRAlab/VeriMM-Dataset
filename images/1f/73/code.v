module DAC_8bit(  
    input [7:0] digital_input,  
    output [3:0] analog_output  
);  
    assign analog_output = digital_input[7:4]; // For simplicity, using higher 4 bits as output  
endmodule