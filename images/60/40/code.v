module sr_latch (
    input s,
    input r,
    output reg q,
    output q_bar
);

    always @ (*) begin
        if (s && r)
            q <= 1'bx;
        else if (s)
            q <= 1'b1;
        else if (r)
            q <= 1'b0;
    end

    assign q_bar = ~q;

endmodule