module qam_modulator (
    input [3:0] data_in,
    output reg [3:0] symbol_out
);
    always @(*) begin
        case (data_in)
            4'b0000: symbol_out = 4'b0000; // Symbol 0
            4'b0001: symbol_out = 4'b0001; // Symbol 1
            4'b0010: symbol_out = 4'b0010; // Symbol 2
            4'b0011: symbol_out = 4'b0011; // Symbol 3
            4'b0100: symbol_out = 4'b0100; // Symbol 4
            4'b0101: symbol_out = 4'b0101; // Symbol 5
            4'b0110: symbol_out = 4'b0110; // Symbol 6
            4'b0111: symbol_out = 4'b0111; // Symbol 7
            4'b1000: symbol_out = 4'b1000; // Symbol 8
            4'b1001: symbol_out = 4'b1001; // Symbol 9
            4'b1010: symbol_out = 4'b1010; // Symbol 10
            4'b1011: symbol_out = 4'b1011; // Symbol 11
            4'b1100: symbol_out = 4'b1100; // Symbol 12
            4'b1101: symbol_out = 4'b1101; // Symbol 13
            4'b1110: symbol_out = 4'b1110; // Symbol 14
            4'b1111: symbol_out = 4'b1111; // Symbol 15
            default: symbol_out = 4'b0000; // Default case
        endcase
    end
endmodule