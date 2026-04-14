module decoder_3to8(
    input en,
    input [2:0] d,
    output reg [7:0] y
);
    always @(*) begin
        if (en) begin
            y = 8'b00000001 << d;
        end else begin
            y = 8'b00000000;
        end
    end
endmodule