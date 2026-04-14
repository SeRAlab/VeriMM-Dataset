module adc_8bit (
    input [7:0] binary_input,
    output reg [9:0] decimal_output
);
    always @(*) begin
        decimal_output = binary_input; // Direct conversion from binary to decimal
    end
endmodule