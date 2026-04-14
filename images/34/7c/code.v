module adc_to_digital (  
    input [23:0] adc_input,  
    output reg [7:0] digital_output  
);  
    always @(*) begin  
        digital_output = adc_input >> 8; // Divide by 256 (2^8)  
    end  
endmodule