module adc_processor (
    input [23:0] adc_value,    // 24-bit ADC input
    output reg [11:0] scaled_value, // 12-bit scaled output
    output reg half_flag        // Flag for upper/lower half
);
    
    always @(*) begin
        // Scale the 24-bit value to 12-bit signed integer range (-2048 to +2047)
        scaled_value = adc_value[23:12] - 12'd2048; // Shift to get signed value
        
        // Determine the half flag
        if (adc_value[23:16] > 8'd0) begin
            half_flag = 1'b1; // Upper half
        end else begin
            half_flag = 1'b0; // Lower half
        end
    end
endmodule