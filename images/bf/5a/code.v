module top_module(
    input R,
    input S,
    output Q,
    output Qbar
    );assign #2 Q = ~ (R | Qbar);
    assign #2 Qbar = ~ (S | Q);
endmodule