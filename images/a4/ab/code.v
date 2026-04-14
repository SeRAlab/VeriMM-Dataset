module top_module(
    input D,Enable,
    output Q,Qbar
    );assign #2 Q_i = Q;
    assign #2 Qbar_i = Qbar;
    assign #2 Q = ~ ((~D&Enable) | Qbar);
    assign #2 Qbar = ~ ((D&Enable) | Q);
endmodule