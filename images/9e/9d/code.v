module top_module(
    CLK,
    D,
    SCD,
    SCE,
    SET_B,
    EN,
    Q
);input CLK;
    input D;
    input SCD;
    input SCE;
    input SET_B;
    input EN;
    output Q;

    reg Q_reg;
    always @(posedge CLK) begin
        if (EN == 1'b0) begin
            Q_reg <= 1'b0;
        end else if (SCD == 1'b1) begin
            Q_reg <= 1'b0;
        end else if (SET_B == 1'b1) begin
            Q_reg <= 1'b1;
        end else if (SCE == 1'b1) begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;

endmodule