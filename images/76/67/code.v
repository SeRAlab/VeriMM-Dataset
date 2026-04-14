module top_module(a, b, s, f);input a;
    input b;
    input s;
    output f;

    assign f = (~s)&a || s&b;endmodule