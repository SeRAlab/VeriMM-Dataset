module top_module(
    input D,
    input GATE,
    output Q,
    output Q_N
);reg Q_reg;
    assign Q = Q_reg;
    assign Q_N = ~Q_reg;

    always @(posedge GATE) begin
        if (GATE) begin
            Q_reg <= D;
        end
    end

endmodule