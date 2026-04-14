module top_module(
    RESET_B,
    CLK_N  ,
    D      ,
    Q      ,
    ctrl_a ,
    ctrl_b
);input  RESET_B;
    input  CLK_N  ;
    input  D      ;
    output Q      ;
    input  ctrl_a ;
    input  ctrl_b ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    reg Q_reg;
    always @(negedge CLK_N or negedge RESET_B) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0;
        end else begin
            case ({ctrl_a, ctrl_b})
                2'b00: Q_reg <= 1'b0;
                2'b01: Q_reg <= ~D;
                2'b10: Q_reg <= D;
                2'b11: Q_reg <= 1'b1;
            endcase
        end
    end

    assign Q = Q_reg;

endmodule