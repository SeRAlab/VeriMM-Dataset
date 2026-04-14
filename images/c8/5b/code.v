module my_module(
    input wire [31:0] in,
    output wire [31:0] out
);

    assign out = (in >= 100) ? 32'h64 : ((in <= -100) ? -32'h64 : in);

endmodule