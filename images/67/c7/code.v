module top_module(
    input D,
    output Q,
    output Q_N,
    input SET_B,
    input SCD,
    input SCE,
    input CLK,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);reg Q_reg, Q_N_reg;
    wire Q_wire, Q_N_wire;
    
    // SET_B control logic
    always @ (SET_B) begin
        if (SET_B) begin
            Q_reg <= 1;
            Q_N_reg <= 0;
        end
    end
    
    // Data signal logic
    always @ (posedge CLK) begin
        if (!SET_B) begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end
    
    // Output signals
    assign Q_wire = Q_reg;
    assign Q_N_wire = Q_N_reg;
    assign Q = (SCD && !SCE) ? Q_wire : Q_reg;
    assign Q_N = (SCD && !SCE) ? Q_N_wire : Q_N_reg;

endmodule