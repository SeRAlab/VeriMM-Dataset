module ADC_Decoder (
    input [23:0] binary_input,
    output reg [31:0] decimal_output
);
    always @(*) begin
        decimal_output = binary_input; // Simply assign the input to output, as it is already in the correct format.
    end
endmodule