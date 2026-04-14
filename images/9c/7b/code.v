module top_module(
    Q  ,
    Q_N,
    CLK,
    D  ,
    SCD,
    SCE
);// Module ports
    output Q  ;
    output Q_N;
    input  CLK;
    input  D  ;
    input  SCD;
    input  SCE;

    // Local signals
    wire buf_D  ;
    wire buf_mux_out ;
    wire and_SCD_not_SCE ;
    wire and_not_SCD_SCE ;
    wire and_SCD_SCE ;
    wire not_SCD ;
    wire not_SCE ;
    wire and_not_SCD_not_SCE ;
    wire mux_out ;

    // Gates
    assign buf_D = D;
    assign not_SCD = ~SCD;
    assign not_SCE = ~SCE;
    assign and_SCD_not_SCE = SCD & not_SCE;
    assign and_not_SCD_SCE = not_SCD & SCE;
    assign and_SCD_SCE = SCD & SCE;
    assign and_not_SCD_not_SCE = not_SCD & not_SCE;

    // 4-to-1 MUX implementation using assign statement
    assign mux_out = 
        (and_not_SCD_not_SCE ? buf_D :
        and_SCD_not_SCE ? buf_mux_out :
        and_not_SCD_SCE ? 1'b0 :  // place holder for actual value if required
        (and_SCD_SCE ? 1'b1 : buf_mux_out)); // placeholder for actual value if required

    // D Flip-Flop implementation
    reg dff_reg;
    always @(posedge CLK) begin
        dff_reg <= mux_out;
    end
    assign buf_mux_out = dff_reg;

    // Output assignments
    assign Q_N = ~buf_mux_out;
    assign Q = buf_mux_out;

endmodule