module decoder_4to16(
    input enable,
    input [3:0] in,
    output reg [15:0] out
);
    always @(*) begin
        if (enable) begin
            out = 16'b0000000000000001 << in;
        end else begin
            out = 16'b0000000000000000;
        end
    end
endmodule