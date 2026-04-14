module huffman_encoder (
    input [3:0] data_in,
    output reg [2:0] data_out
);
    always @(*) begin
        case (data_in)
            4'b0000: data_out = 3'b000; // 0
            4'b0001: data_out = 3'b001; // 1
            4'b0010: data_out = 3'b010; // 2
            4'b0011: data_out = 3'b011; // 3
            4'b0100: data_out = 3'b100; // 4
            4'b0101: data_out = 3'b101; // 5
            4'b0110: data_out = 3'b110; // 6
            4'b0111: data_out = 3'b111; // 7
            default: data_out = 3'b111;  // Invalid character
        endcase
    end
endmodule