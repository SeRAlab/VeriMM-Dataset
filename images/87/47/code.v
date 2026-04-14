module decoder_3to8 (
    input [2:0] in,
    input enable,
    output reg [7:0] out
);

    always @(*) begin
        if (enable) begin
            out = 8'b00000001 << in;
        end else begin
            out = 8'b00000000;
        end
    end
endmodule