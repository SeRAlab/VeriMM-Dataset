module decoder_2to4(
    input enable_n,
    input [1:0] d,
    output reg [3:0] y
);

always @(*) begin
    if (!enable_n)
        y = 4'b0001 << d;
    else
        y = 4'b0000;
end

endmodule