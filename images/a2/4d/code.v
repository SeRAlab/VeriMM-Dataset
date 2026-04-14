module d_latch (
    input enable,
    input d,
    output reg q
);

    always @(*) begin
        if (enable)
            q <= d;
    end

endmodule