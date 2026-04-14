module DAC_24bit (  
    input wire [23:0] digital_input,  
    output reg [23:0] analog_output  
);  
    always @(*) begin  
        analog_output = digital_input;  
    end  
endmodule