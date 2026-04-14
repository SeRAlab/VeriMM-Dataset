module DAC_16bit (  
    input [15:0] dac_input,  
    output [15:0] dac_output  
);  
    assign dac_output = dac_input;  
endmodule