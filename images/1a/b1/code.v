module QAM_Modulator (
    input [3:0] data_in,
    output reg [3:0] modulated_out
);
    always @(data_in) begin
        case (data_in)
            4'b0000: modulated_out = 4'b0000; // 00 -> 00
            4'b0001: modulated_out = 4'b0001; // 01 -> 01
            4'b0010: modulated_out = 4'b0010; // 10 -> 10
            4'b0011: modulated_out = 4'b0011; // 11 -> 11
            4'b0100: modulated_out = 4'b0000; // 00 -> 00
            4'b0101: modulated_out = 4'b0001; // 01 -> 01
            4'b0110: modulated_out = 4'b0010; // 10 -> 10
            4'b0111: modulated_out = 4'b0011; // 11 -> 11
            4'b1000: modulated_out = 4'b0000; // 00 -> 00
            4'b1001: modulated_out = 4'b0001; // 01 -> 01
            4'b1010: modulated_out = 4'b0010; // 10 -> 10
            4'b1011: modulated_out = 4'b0011; // 11 -> 11
            4'b1100: modulated_out = 4'b0000; // 00 -> 00
            4'b1101: modulated_out = 4'b0001; // 01 -> 01
            4'b1110: modulated_out = 4'b0010; // 10 -> 10
            4'b1111: modulated_out = 4'b0011; // 11 -> 11
            default: modulated_out = 4'b0000; // Default case
        endcase
    end
endmodule