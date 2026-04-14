module top_module(
    input Uin,
    input Din,
    input Lin,
    input Rin,
    output Uout,
    output Dout,
    output Lout,
    output Rout
    );assign Uout = Uin & ~Din;
    assign Dout = ~Uin & Din;
    assign Lout = Lin & ~Rin;
    assign Rout = ~Lin & Rin;
endmodule