module top_module(
    input CLK,
    input RESET_B,
    input SCD,
    input SCE,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q,
    output reg Q_N
);// Internal signals
    reg Q_int;
    reg Q_N_int;

    // Assign initial values
    assign VPWR = 1'b1;
    assign VGND = 1'b0;
    assign VPB = 1'b1;
    assign VNB = 1'b0;
    initial Q_int = 1'b0;
    initial Q_N_int = 1'b1;

    // Synchronous reset and set
    always @(posedge CLK)
    begin
        if (RESET_B == 1'b0)
        begin
            Q_int <= 1'b0;
            Q_N_int <= 1'b1;
        end
        else if (SCD == 1'b0)
        begin
            Q_int <= 1'b0;
            Q_N_int <= 1'b1;
        end
        else if (SCE == 1'b0)
        begin
            Q_int <= 1'b1;
            Q_N_int <= 1'b0;
        end
        else
        begin
            Q_int <= D;
            Q_N_int <= ~D;
        end
    end

    // Assign outputs
    assign Q = Q_int;
    assign Q_N = Q_N_int;

endmodule