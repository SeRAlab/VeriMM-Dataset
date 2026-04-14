module top_module(
    Q,
    CLK,
    D,
    SCD,
    SCE,
    RESET_B
);output Q;
    input CLK;
    input D;
    input SCD;
    input SCE;
    input RESET_B;

    reg Q;

    always @(posedge CLK) begin
        if (RESET_B == 1'b1) begin
            Q <= 1'b0;
        end else if (SCD == 1'b1) begin
            Q <= D;
        end else if (SCE == 1'b0) begin
            Q <= Q;
        end else begin
            Q <= D;
        end
    end

endmodule