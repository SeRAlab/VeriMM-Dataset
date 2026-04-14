module DAC_16bit(  
    input [15:0] binary_in,  
    output [15:0] analog_out  
);  
    assign analog_out = binary_in;  
endmodule