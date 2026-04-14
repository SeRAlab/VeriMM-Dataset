module adc_8to4 (
    input [7:0] analog_input,
    output reg [3:0] digital_output
);

always @(*) begin
    digital_output = analog_input >> 4; // Scale down by 16
end

endmodule