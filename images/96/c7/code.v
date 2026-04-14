module top_module(
    input D,
    input Enable,
    output Q,
    output Qbar
    );assign #2 R_i = ~D & Enable;
    assign #2 S_i = D & Enable;
    assign #2 Q_i = Q;
    assign #2 Qbar_i = Qbar; 
    assign #2 Q = ~ (R_i | Qbar_i);
    assign #2 Qbar = ~ (S_i | Q_i);

endmodule