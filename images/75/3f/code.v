module decoder_2to4 (
        input [1:0] a,
        input en,
        output [3:0] y);

    assign y = en ? (4'b0001 << a) : 4'b0000;

endmodule