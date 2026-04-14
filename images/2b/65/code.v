module DAC_16bit (
    input [3:0] digital_in,
    output reg [15:0] analog_out
);
    always @(*) begin
        analog_out = digital_in * 16384; // 65535 / 15 = 4369 (approximately)
    end
endmodule