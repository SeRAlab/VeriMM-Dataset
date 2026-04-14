module decoder_3to8 (
    input [2:0] a,
    input en,
    output reg [7:0] y
);

    always @(*) begin
        if (en)
            y = 1 << a;
        else
            y = 8'b00000000;
    end
endmodule