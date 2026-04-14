module top_module(D, SET_B, VPWR, VGND, Q, Q_N, CLK);input D;
    input SET_B;
    input VPWR;
    input VGND;
    output Q;
    output Q_N;
    input CLK;

    reg Q_reg;
    reg Q_N_reg;

    always @(posedge CLK) begin
        if (SET_B == 1'b0) begin
            Q_reg <= 1'b0;
            Q_N_reg <= 1'b1;
        end else begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end

    assign Q = Q_reg;
    assign Q_N = Q_N_reg;

endmodule