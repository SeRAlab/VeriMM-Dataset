module adc_8bit_to_3bit (  
    input [7:0] adc_input,  
    output reg [2:0] scaled_output  
);  
    always @* begin  
        scaled_output = adc_input / 32;  
    end  
endmodule