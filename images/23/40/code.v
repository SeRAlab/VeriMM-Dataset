module adc_decoder (
    input [15:0] adc_value,
    output reg [1:0] range_code
);
    always @(*) begin
        if (adc_value <= 16'h0FFF) 
            range_code = 2'b00; // 0-4095
        else if (adc_value <= 16'h1FFF) 
            range_code = 2'b01; // 4096-8191
        else if (adc_value <= 16'h2FFF) 
            range_code = 2'b10; // 8192-12287
        else 
            range_code = 2'b11; // 12288-65535
    end
endmodule