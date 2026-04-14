module dac_24bit (
    input [23:0] input_value,       // 24-bit binary input
    input [11:0] reference_voltage,  // 12-bit reference voltage
    output reg [31:0] v_out          // 32-bit output voltage
);
    always @(*) begin
        // Calculate the output voltage based on the formula
        v_out = (input_value * reference_voltage) >> 12; // Scale down by 2^12 to maintain precision
    end
endmodule