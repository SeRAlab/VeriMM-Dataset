module top_module(
    input D, SCD, SCE, RESET_B, VPWR, VGND, VPB, VNB, CLK,
    output Q, Q_N
);(* sky130_fd_sc_lp = "true" *)
    (* dont_use = "true" *)
    wire [1:0] nand_out;
    wire [1:0] nand_out_next;

    assign nand_out[0] = ~(D & ~SCE & nand_out[1]);
    assign nand_out[1] = ~(~D & ~SCD & nand_out[0]);

    assign nand_out_next[0] = ~(D & ~SCE & nand_out[1]);
    assign nand_out_next[1] = ~(~D & ~SCD & nand_out[0]);

    (* sky130_fd_sc_lp = "true" *)
    (* dont_use = "true" *)
    reg Q_reg, Q_N_reg;
    always @(posedge CLK or negedge RESET_B)
    begin
        if (~RESET_B) begin
            Q_reg <= 1'b0;
            Q_N_reg <= 1'b1;
        end else begin
            Q_reg <= nand_out_next[1];
            Q_N_reg <= nand_out_next[0];
        end
    end

    assign Q = Q_reg;
    assign Q_N = Q_N_reg;

endmodule