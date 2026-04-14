module decoder_3to8 (
    input [2:0] a,
    input enable,
    output reg [7:0] y
);

    // Decoder logic
    always @(*) begin
        if (enable)
            y = 1 << a;
        else
            y = 8'b00000000;
    end

endmodule