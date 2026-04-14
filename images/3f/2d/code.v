module adc_interface (
    input [23:0] adc_input,
    input valid,
    output reg [11:0] adc_output
);
    always @(*) begin
        if (valid) begin
            adc_output = adc_input[23:12]; // Take the most significant 12 bits
        end else begin
            adc_output = 12'b000000000000; // If not valid, output is 0
        end
    end
endmodule