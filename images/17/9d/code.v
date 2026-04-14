module dac_16bit (
    input [15:0] digital_input,
    output reg [15:0] analog_output
);

    always @(*) begin
        analog_output = (digital_input * 5) >> 16; // Scale to 5V range
    end

endmodule