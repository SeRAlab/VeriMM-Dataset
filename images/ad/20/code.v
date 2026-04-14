module binary_decoder_2to4 (
    input wire [1:0] binary_in,
    output reg [3:0] decoder_out
    );

always @(*) begin
    case (binary_in)
        2'b00: decoder_out = 4'b0001;
        2'b01: decoder_out = 4'b0010;
        2'b10: decoder_out = 4'b0100;
        2'b11: decoder_out = 4'b1000;
        default: decoder_out = 4'b0000;
    endcase
end

endmodule