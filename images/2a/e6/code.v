module dac_8bit(
    input [7:0] digital_input,
    output reg [9:0] analog_output
);
    parameter V_ref = 5; // Reference voltage
    always @(*) begin
        analog_output = (digital_input * V_ref * 1024) / 255; // Scale to 10-bit
    end
endmodule