module voltage_sensor(
    input [4:0] input_voltage,
    input [4:0] reference_voltage,
    output reg output_signal
);
    always @(*) begin
        if (input_voltage > reference_voltage)
            output_signal = 1'b1;
        else
            output_signal = 1'b0;
    end
endmodule