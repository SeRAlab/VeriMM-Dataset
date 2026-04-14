module top_module(
    output Q,
    output Q_N,
    input D,
    input CLK,
    input SET_B,
    input RESET_B,
    input VPWR,
    input VGND
);wire Q_int, Q_N_int;
    reg Q_reg, Q_N_reg;

    assign Q = Q_int;
    assign Q_N = Q_N_int;

    always @(posedge CLK or negedge SET_B or negedge RESET_B) begin
        if (!SET_B) begin
            Q_reg <= 1'b1;
            Q_N_reg <= 1'b0;
        end else if (!RESET_B) begin
            Q_reg <= 1'b0;
            Q_N_reg <= 1'b1;
        end else begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end

    assign Q_int = Q_reg;
    assign Q_N_int = Q_N_reg;

endmodule