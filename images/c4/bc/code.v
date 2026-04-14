module flip_flop (
    Q,
    Q_N,
    CLK,
    D,
    SCD,
    SCE
);

    output Q;
    output Q_N;
    input CLK;
    input D;
    input SCD;
    input SCE;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    reg Q;
    assign Q_N = ~Q;

    always @(posedge CLK) begin
        if (SCD) begin
            Q <= 0;
        end else if (SCE) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule