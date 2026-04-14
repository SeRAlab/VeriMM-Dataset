module top_module(
    input a,b,c,d, output e,f,g
    );assign e = ~(a&b);
    assign f = ~(e&c);
    assign g = ~(f&d);
endmodule