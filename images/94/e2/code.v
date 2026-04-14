module custom_logic (
    input x,
    input y,
    input z,
    input w,
    output reg u);assign u = ~x&y&~z&w | x&y&z&~w | x&~y&z&w | x&y&~z&w | ~x&y&z&~w;

endmodule