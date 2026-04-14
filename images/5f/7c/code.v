module top_module(a, b, c, g, p, s);input a;
    input b;
    input c;

    output p;
    output g;
    output s;

    assign s = a ^ b ^ c;
    assign p = a + b;
    assign g = a & b;
endmodule