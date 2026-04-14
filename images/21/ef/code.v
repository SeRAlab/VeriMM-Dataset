module DAC (
    input [7:0] bin_input,
    output reg [9:0] analog_output
);
    always @(*) begin
        analog_output = bin_input * 1023 / 255; // scale 8-bit to 10-bit output
    end
endmodule