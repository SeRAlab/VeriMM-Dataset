module adc_8bit_to_4bit (  
    input [7:0] analog_in,  
    output reg [3:0] digital_out  
);  
    always @(*) begin  
        // Quantization: Scale down 8-bit input to 4-bit output  
        digital_out = analog_in >> 4;  
    end  
endmodule