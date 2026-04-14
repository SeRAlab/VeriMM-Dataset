module top_module(c3, c2, c1, c0, out);input c3;
    input c2;
    input c1;
    input c0;
    output out;
    assign out = ~c3&~c2&c1&c0 | ~c3&c2&~c1&~c0 | ~c3&c2&~c1&c0 | ~c3&c2&c1&c0 | c3&~c2&~c1&c0;endmodule