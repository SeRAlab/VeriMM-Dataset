module adc_converter (
    input [7:0] analog_input,
    output reg [2:0] digital_output
);
    always @(*) begin
        if (analog_input < 64)
            digital_output = 3'b000;
        else if (analog_input < 128)
            digital_output = 3'b001;
        else if (analog_input < 192)
            digital_output = 3'b010;
        else if (analog_input <= 255)
            digital_output = 3'b011;
        else
            digital_output = 3'b111; // Out of bounds case
    end
endmodule