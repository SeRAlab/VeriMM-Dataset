module adc_processor (
    input [7:0] adc_input,
    input valid,
    output reg [9:0] adc_output
);

always @(*) begin
    if (valid) begin
        adc_output = adc_input * 4;
    end else begin
        adc_output = 10'b0; // Output is zero when not valid
    end
end

endmodule