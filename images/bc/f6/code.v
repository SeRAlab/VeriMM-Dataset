module top_module(
    Q       ,
    Q_N     ,
    CLK     ,
    D       ,
    SET_B   ,
    RESET_B ,
    VPWR    ,
    VGND
);output Q       ;
    output Q_N     ;
    input  CLK     ;
    input  D       ;
    input  SET_B   ;
    input  RESET_B ;
    input  VPWR    ;
    input  VGND    ;

    wire Q_int;
    wire Q_N_int;

    // Changed from sky130_fd_sc_hvl__dfsbp to a generic D flip-flop implementation for compatibility
    reg Q_reg;
    always @(posedge CLK or negedge RESET_B or negedge SET_B) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0; // Reset state
        end else if (!SET_B) begin
            Q_reg <= 1'b1; // Set state
        end else begin
            Q_reg <= D;    // Normal operation
        end
    end

    assign Q_int = Q_reg;
    assign Q_N_int = ~Q_reg;

    // Connect outputs
    assign Q = RESET_B ? 1'b0 : Q_int;
    assign Q_N = RESET_B ? 1'b1 : Q_N_int;

endmodule