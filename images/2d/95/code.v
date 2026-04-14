module adc_8bit (
    input [9:0] adc_input,
    input valid,
    output reg [7:0] adc_output
);
    always @(*) begin
        if (valid) begin
            adc_output = adc_input[9:2]; // Truncate to the upper 8 bits
        end else begin
            adc_output = 8'b00000000; // Output zero if not valid
        end
    end
endmodule