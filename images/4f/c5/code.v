module top_module(c0, c1, c2, c3, seg4);input c0;
    input c1;
    input c2;
    input c3;
    output seg4;
    assign seg4 = (~c3 & c0) |
    (~c3 & c2 & ~c1) |
    (~c2 & ~c1 & c0);endmodule