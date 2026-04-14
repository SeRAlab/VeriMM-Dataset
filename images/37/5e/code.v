module adc_converter (
    input [15:0] binary_input,
    input valid,
    output reg [15:0] hex_output
);

always @(*) begin
    if (valid) begin
        hex_output = binary_input; // Directly assign binary to hex output
    end else begin
        hex_output = 16'h0000; // If not valid, output zero
    end
end

endmodule