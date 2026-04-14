module top_module(
    input [3:0] in,
    output reg [1:0] pos
);wire [3:0] gray;
    wire [3:0] one_hot;

    // Binary to gray code converter
    assign gray[0] = in[0];
    assign gray[1] = in[0] ^ in[1];
    assign gray[2] = in[1] ^ in[2];
    assign gray[3] = in[2] ^ in[3];

    // Binary to one-hot decoder
    assign one_hot[0] = ~(in[0] | in[1] | in[2] | in[3]);
    assign one_hot[1] = in[0] & ~in[1] & ~in[2] & ~in[3];
    assign one_hot[2] = ~in[0] & in[1] & ~in[2] & ~in[3];
    assign one_hot[3] = ~in[0] & ~in[1] & in[2] & ~in[3];
    // Removed one_hot[4] as it is out of range for a 4-bit wire

    // Priority encoder
    always @* begin
        case (gray)
            4'b0000: pos = 2'b00;
            4'b0001: pos = 2'b01;
            4'b0011: pos = 2'b10;
            4'b0111: pos = 2'b11;
            default: pos = 2'b00;
        endcase
    end

endmodule