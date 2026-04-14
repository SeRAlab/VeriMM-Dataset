module top_module(
    Q,
    Q_N,
    CLK,
    D,
    SET,
    CLR
);output Q;
    output Q_N;
    input CLK;
    input D;
    input SET;
    input CLR;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    reg Q_reg;
    assign Q = Q_reg;
    assign Q_N = ~Q_reg;

    always @(posedge CLK) begin
        if (SET) begin
            Q_reg <= 1;
        end else if (CLR) begin
            Q_reg <= 0;
        end else begin
            Q_reg <= D;
        end
    end

endmodule