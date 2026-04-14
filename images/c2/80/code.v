module digital_circuit (
    input D,
    output Q,
    input RESET_B,
    input GATE
);

    reg Q_reg;

    always @(posedge GATE) begin
        if (RESET_B == 0) begin
            Q_reg <= 0;
        end else begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;

endmodule