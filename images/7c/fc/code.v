module decoder2to4(
    input [1:0] in,
    input enable,
    output reg [3:0] out
);

    always @(*) begin
        if (enable)
            out = 4'b0001 << in;
        else
            out = 4'b0000;
    end

endmodule