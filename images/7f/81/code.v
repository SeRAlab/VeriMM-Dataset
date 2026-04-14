module decoder_3to8 (
    input [2:0] a,
    output reg [7:0] y
);

    always @(*) begin
        y = 8'b00000000;
        y[a] = 1;
    end

endmodule