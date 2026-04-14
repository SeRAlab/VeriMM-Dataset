module qam_modulator (
    input [2:0] data_in,
    output reg [2:0] amplitude_out
);
    always @(*) begin
        case (data_in)
            3'b000: amplitude_out = 3'b000; // 0
            3'b001: amplitude_out = 3'b001; // 1
            3'b010: amplitude_out = 3'b010; // 2
            3'b011: amplitude_out = 3'b011; // 3
            3'b100: amplitude_out = 3'b100; // 4
            3'b101: amplitude_out = 3'b101; // 5
            3'b110: amplitude_out = 3'b110; // 6
            3'b111: amplitude_out = 3'b111; // 7
            default: amplitude_out = 3'b000; // default case
        endcase
    end
endmodule