module top_module(
    input D,
    input Enable,
    output Q,
    output Qbar
    );wire D_i;
    
    assign #2 D_i = ~D;
    assign #2 Q = ~(Enable & D_i |Qbar);
    assign #2 Qbar = ~(Enable & D |Q);
endmodule