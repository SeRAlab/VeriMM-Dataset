module top_module(
    input x,y,z,
    output p,q,r
    );assign p = x;
    assign q = ~x&y ^ x&z;
    assign r = ~x&z ^ x&y;
endmodule