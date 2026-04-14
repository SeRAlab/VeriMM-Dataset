module decoder_4to16 (
    input wire [3:0] a,
    output wire [15:0] y
);

assign y = 1 << a;

endmodule