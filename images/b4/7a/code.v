module top_module(
    input a,b,c, output d,e
    );assign d = ~(a|b);
    assign e = ~(d|c);
endmodule