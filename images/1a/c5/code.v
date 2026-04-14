module dynamic_range_compressor(
    input signed [4:0] in,
    output reg signed [4:0] out
);
    always @(*) begin
        if (in > 5'd15) 
            out = in >>> 1; // Right shift by 1 (divide by 2)
        else if (in > 5'd8) 
            out = in - 5'd2;
        else 
            out = in;
    end
endmodule