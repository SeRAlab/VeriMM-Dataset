module huffman_encoding (
    input [3:0] data_in,
    output reg [2:0] data_out
);

always @(*) begin
    case(data_in)
        4'b0000: data_out = 3'b000;
        4'b0001: data_out = 3'b001;
        4'b0010: data_out = 3'b010;
        4'b0011: data_out = 3'b011;
        4'b0100: data_out = 3'b100;
        4'b0101: data_out = 3'b101;
        4'b0110: data_out = 3'b110;
        4'b0111: data_out = 3'b111;
        default: data_out = 3'b111; // invalid encoding
    endcase
end

endmodule