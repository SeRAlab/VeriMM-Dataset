module top_module(q, qbar, set, reset);output q, qbar;
    input set, reset;

    nor #1 (q, qbar, reset);
    nor #1 (qbar, q, set);
endmodule