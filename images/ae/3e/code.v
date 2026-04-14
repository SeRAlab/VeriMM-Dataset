module decoder3to8 (
    input wire [2:0] d,
    output wire [7:0] y
);

    assign y = 1 << d;

endmodule