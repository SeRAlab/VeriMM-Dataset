module adc_simulator (
    input [23:0] adc_input,
    output reg [7:0] adc_output
);
    always @(*) begin
        adc_output = adc_input[23:16]; // Take the top 8 bits
    end
endmodule