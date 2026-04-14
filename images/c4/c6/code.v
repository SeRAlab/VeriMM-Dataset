module flip_flop (
    output Q,
    output Q_N,
    input CLK,
    input D,
    input SCD,
    input SCE,
    input SET_B
);

    reg Q_reg, Q_N_reg;

    always @(posedge CLK) begin
        if (SET_B) begin
            Q_reg <= 1'b1;
            Q_N_reg <= 1'b0;
        end else if (SCD) begin
            Q_reg <= 1'b0;
            Q_N_reg <= 1'b1;
        end else if (SCE) begin
            Q_reg <= 1'b1;
            Q_N_reg <= 1'b0;
        end else begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end

    assign Q = Q_reg;
    assign Q_N = Q_N_reg;

endmodule