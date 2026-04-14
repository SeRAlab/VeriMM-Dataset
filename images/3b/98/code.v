module adc_24_to_12 (  
    input wire [23:0] adc_input,  
    input wire enable,  
    output reg [11:0] adc_output  
);  
    always @(*) begin  
        if (enable)  
            adc_output = adc_input[11:0];  
        else  
            adc_output = adc_output; // retain last output  
    end  
endmodule