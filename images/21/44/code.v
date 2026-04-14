module DAC (
    input [7:0] binary_input,
    output reg [9:0] analog_output
);
    parameter VREF = 5; // Reference voltage (5V)
    parameter MAX_DIGITAL = 255; // Max value for 8-bit input

    always @(*) begin
        // Scale the 8-bit input to a 10-bit output, while considering the reference voltage
        analog_output = (binary_input * (1023 * VREF)) / MAX_DIGITAL;
    end
endmodule