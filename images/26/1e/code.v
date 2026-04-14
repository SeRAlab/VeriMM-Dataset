module adc_output_processor (
    input [23:0] adc_input,
    output reg [7:0] adc_output
);
    parameter THRESHOLD = 24'h800000; // 2^23
    
    always @(*) begin
        if (adc_input < THRESHOLD) 
            adc_output = 8'b0;
        else 
            adc_output = adc_input[23:16]; // Upper 8 bits
    end
endmodule