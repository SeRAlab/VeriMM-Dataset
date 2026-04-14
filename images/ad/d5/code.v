module decoder_4to16(
    input enable,
    input [3:0] d,
    output reg [15:0] y
);

always @(*) begin
    if (enable)
        y = 16'b0000_0000_0000_0001 << d;
    else
        y = 16'b0000_0000_0000_0000;
end

endmodule