module dff_en_rst (
    input D, C, E, R,
    output Q
);

reg Q_reg;

always @(posedge C) begin
    if (R == 0) begin
        Q_reg <= 0;
    end else if (E == 1) begin
        Q_reg <= D;
    end
end

assign Q = Q_reg;

endmodule