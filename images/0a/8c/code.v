module huffman_encoder (
    input [3:0] char_in,
    input valid_in,
    output reg [7:0] encoded_out,
    output reg valid_out
);

always @(*) begin
    valid_out = 0; // Default output valid to 0
    case (char_in)
        4'b0000: begin // A
            encoded_out = 8'b00000001; // 1
            valid_out = valid_in; // Output valid if input valid
        end
        4'b0001: begin // B
            encoded_out = 8'b00000010; // 10
            valid_out = valid_in;
        end
        4'b0010: begin // C
            encoded_out = 8'b00000100; // 100
            valid_out = valid_in;
        end
        4'b0011: begin // D
            encoded_out = 8'b00001000; // 1000
            valid_out = valid_in;
        end
        4'b0100: begin // E
            encoded_out = 8'b00010000; // 10000
            valid_out = valid_in;
        end
        default: begin
            encoded_out = 8'b00000000; // Default case
            valid_out = 0; // Invalid output
        end
    endcase
end

endmodule