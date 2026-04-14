module top_module(
    input D,
    input SET_B,
    input SCD,
    input SCE,
    input CLK,
    output Q,
    output Q_N
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Internal signals
    reg q_reg;
    wire q_n_wire;

    // D flip-flop
    always @(posedge CLK) begin
        if (SET_B == 1'b0) begin
            q_reg <= 1'b0;
        end else begin
            q_reg <= D;
        end
    end

    // Output signals
    assign Q = q_reg;
    assign Q_N = ~q_reg;

endmodule