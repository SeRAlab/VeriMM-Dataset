module top_module(
    input [3:0] in,
    output reg [1:0] pos
);// Binary-to-Gray code converter
    wire [3:0] gray;
    assign gray[0] = in[0];
    assign gray[1] = in[0] ^ in[1];
    assign gray[2] = in[1] ^ in[2];
    assign gray[3] = in[2] ^ in[3];

    // Gray-to-binary code converter
    always @* begin
        case (gray)
            4'b0001: pos = 2'b00;
            4'b0010: pos = 2'b01;
            4'b0100: pos = 2'b10;
            4'b1000: pos = 2'b11;
            default: pos = 2'b00;
        endcase
    end

endmodule