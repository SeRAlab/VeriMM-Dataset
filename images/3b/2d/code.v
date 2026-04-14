module huffman_encoder (
    input [3:0] symbol,
    output reg [3:0] encoded_output, // max length of encoded_output is 4 bits
    output reg [3:0] encoded_length   // length of the encoded output
);

always @(*) begin
    case (symbol)
        4'b0000: begin
            encoded_output = 4'b0000; // '00'
            encoded_length = 4'd2;
        end
        4'b0001: begin
            encoded_output = 4'b0001; // '01'
            encoded_length = 4'd2;
        end
        4'b0010: begin
            encoded_output = 4'b0010; // '10'
            encoded_length = 4'd2;
        end
        4'b0011: begin
            encoded_output = 4'b0110; // '110'
            encoded_length = 4'd3;
        end
        4'b0100: begin
            encoded_output = 4'b1110; // '1110'
            encoded_length = 4'd4;
        end
        4'b0101: begin
            encoded_output = 4'b1111; // '1111'
            encoded_length = 4'd4;
        end
        default: begin
            encoded_output = 4'b0000; // Default case
            encoded_length = 4'd0;
        end
    endcase
end

endmodule