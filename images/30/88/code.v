module adc_converter (
    input [7:0] analog_input,
    output reg [3:0] digital_output
);
    always @(*) begin
        if (analog_input > 8'd255) begin
            digital_output = 4'b0000; // Invalid input, output zero
        end else begin
            digital_output = analog_input[7:4]; // Take upper 4 bits
        end
    end
endmodule