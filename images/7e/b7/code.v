module top_module(c0, c1, c2, c3, seg3);input c0;
    input c1;
    input c2;
    input c3;
    output seg3;
    assign seg3 = (~c3 & c2 & ~c1 & ~c0) |
    (!c3 & ~c2 & ~c1 & c0) |
    (c2 & c1 & c0) |
    (c3 & ~c2 & c1 & ~c0);endmodule