module adc_8_to_10 (  
    input [7:0] adc_input,  
    output reg [9:0] adc_output  
);  
    always @(*) begin  
        adc_output = (adc_input * 10'd1023) / 8'd255;  
    end  
endmodule