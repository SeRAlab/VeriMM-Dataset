module decoder_3to8 (
        input [2:0] a,
        input en,
        output [7:0] y);

    assign y = en ? (8'b00000001 << a) : 8'b00000000;

endmodule