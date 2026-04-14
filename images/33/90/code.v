module dynamic_range_compressor (
    input signed [3:0] in,
    output reg signed [3:0] out
);
    always @(*) begin
        if (in <= -8)
            out = -8;
        else if (in > -8 && in <= 0)
            out = in >>> 1; // Right shift to divide by 2
        else if (in > 0 && in <= 7)
            out = in;
        else if (in > 7)
            out = 7;
    end
endmodule