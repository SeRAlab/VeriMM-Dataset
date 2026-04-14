module decoder2to4 (
    input wire [1:0] a,
    output wire [3:0] y
);
    wire not_a0, not_a1;

    not (not_a0, a[0]);
    not (not_a1, a[1]);

    and (y[0], not_a1, not_a0);
    and (y[1], not_a1, a[0]);
    and (y[2], a[1], not_a0);
    and (y[3], a[1], a[0]);

endmodule