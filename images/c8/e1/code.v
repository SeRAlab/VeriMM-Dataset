module d_latch_en (
    input D,
    input EN,
    output Q,
    output Q_bar
);

    reg Q_reg;
    assign Q = Q_reg;
    assign Q_bar = ~Q_reg;

    always @(posedge EN)
    begin
        Q_reg <= D;
    end

endmodule