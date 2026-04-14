module top_module(a, b, e, out);input [1:0] a, b;
    input e;
    output out;

    assign out = (~a[1] & ~a[0] & e) | (~a[1] & b[0] & e) | (b[1] & b[0] & e) | (~a[1] & b[1]) | (~a[1] & ~a[0] & b[0]) | (~a[0] & b[1] & b[0]) | (a[1] & ~a[0] & b[1] & e);endmodule