module DAC_16bit (  
    input [15:0] bin_input,  
    output reg [15:0] analog_output  
);  
    always @(*) begin  
        analog_output = bin_input;  // Direct mapping for simplicity  
    end  
endmodule