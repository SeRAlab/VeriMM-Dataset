module DAC_16bit (
    input [15:0] binary_input, // 16-bit binary input
    output reg [15:0] analog_output // 16-bit analog output (scaled)
);
    parameter MAX_VOLTAGE = 5; // Maximum output voltage
    parameter MAX_VALUE = 65535; // Maximum value for 16-bit input

    always @(*) begin
        // Scale the binary input to analog output
        analog_output = (binary_input * MAX_VOLTAGE) / MAX_VALUE;
    end
endmodule