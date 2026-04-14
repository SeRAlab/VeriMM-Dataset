module dff_sky130_fd_sc_ls (
    output Q,
    input CLK,
    input D,
    input DE
);

    reg Q_reg;

    always @(posedge CLK) begin
        if (DE) begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;

endmodule