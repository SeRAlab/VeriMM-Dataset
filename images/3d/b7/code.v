module DAC(
    input [7:0] binary_input,
    output reg [9:0] analog_output
);
    always @(*) begin
        analog_output = binary_input * 10'd256 / 10'd100; // Scaling factor of 2.56 (256/100)
    end
endmodule