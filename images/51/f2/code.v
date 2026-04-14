module sr_latch(
    input s,
    input r,
    output reg q);always @(*) begin
    if (s)
        q = 1;
    else if (r)
        q = 0;
end

endmodule