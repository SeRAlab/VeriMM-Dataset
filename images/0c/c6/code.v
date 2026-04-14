module adc_24_to_decimal (
    input [23:0] binary_input,
    output reg [31:0] decimal_output
);

always @(*) begin
    decimal_output = binary_input; // Directly assign binary to decimal since it is unsigned
end

endmodule