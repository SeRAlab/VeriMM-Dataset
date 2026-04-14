module top_module(
    input      [3:0] dig,
    output reg [7:0] _gfedcba
);reg [6:0] gfedcba;

    always @*
        case (dig)
        4'h0: _gfedcba = 8'b11000000;
        4'h1: _gfedcba = 8'b11111001;
        4'h2: _gfedcba = 8'b10100100;
        4'h3: _gfedcba = 8'b10110000;
        4'h4: _gfedcba = 8'b10011001;
        4'h5: _gfedcba = 8'b10010010;
        4'h6: _gfedcba = 8'b10000010;
        4'h7: _gfedcba = 8'b11111000;
        4'h8: _gfedcba = 8'b10000000;
        4'h9: _gfedcba = 8'b10010000;
        4'ha: _gfedcba = 8'b10001000;
        4'hb: _gfedcba = 8'b10000011;
        4'hc: _gfedcba = 8'b11000110;
        4'hd: _gfedcba = 8'b10100001;
        4'he: _gfedcba = 8'b10000110;
        4'hf: _gfedcba = 8'b10001110;
        endcase

endmodule