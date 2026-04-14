module decoder2to4(
    input [1:0] in,
    output reg [3:0] out
);

    always @(*) begin
        out = 4'b0;
        out[in] = 1'b1;
    end

endmodule