module DVFS_Controller (
    input [1:0] control_signal,
    output reg [3:0] voltage_freq
);
    always @(*) begin
        case (control_signal)
            2'b00: voltage_freq = 4'b0000; // 0V, 0Hz
            2'b01: voltage_freq = 4'b0101; // 1V, 1Hz
            2'b10: voltage_freq = 4'b1010; // 2V, 2Hz
            2'b11: voltage_freq = 4'b1111; // 3V, 3Hz
            default: voltage_freq = 4'b0000; // Default case
        endcase
    end
endmodule