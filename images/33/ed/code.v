module adc_8bit(  
    input [2:0] control,  
    output reg [7:0] adc_output  
);  
    always @(*) begin  
        case(control)  
            3'b000: adc_output = 8'b00000000; // 0V  
            3'b001: adc_output = 8'b00111111; // 0.5V  
            3'b010: adc_output = 8'b01111111; // 1.0V  
            3'b011: adc_output = 8'b01111111; // 1.5V  
            3'b100: adc_output = 8'b10111111; // 2.0V  
            3'b101: adc_output = 8'b11111111; // 2.5V  
            3'b110: adc_output = 8'b11111111; // 3.0V  
            3'b111: adc_output = 8'b11111111; // 3.5V  
            default: adc_output = 8'b00000000; // default case  
        endcase  
    end  
endmodule