module top_module(
    input R,
    input S,
    input Enable,
    output Q,
    output Qbar
    );wire R_i, S_i;
    
    assign #2 R_i = Enable & R;
    assign #2 S_i = Enable & S;
    assign #2 Q = ~ (R_i | Qbar);
    assign #2 Qbar = ~ (S_i | Q);
endmodule