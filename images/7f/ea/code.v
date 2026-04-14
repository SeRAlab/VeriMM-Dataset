module top_module(
    Q      ,
    CLK_N  ,
    D      ,
    SCD    ,
    SCE    ,
    RESET_B
);output reg Q; // Change output to reg type
    input  CLK_N  ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  RESET_B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    reg Q_reg;

    always @ (posedge CLK_N or negedge RESET_B) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0;
        end else if (SCD == 1'b0) begin
            Q_reg <= D;
        end else begin
            Q_reg <= 1'b0;
        end
    end

    always @ (posedge CLK_N) begin
        if (SCE == 1'b0) begin
            Q <= Q_reg; // Assign Q_reg to Q directly
        end
    end

endmodule