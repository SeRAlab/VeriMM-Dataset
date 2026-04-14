module top_module(
    Q   ,
    CLK ,
    D   ,
    SCD ,
    SCE ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Q   ;
    input  CLK ;
    input  D   ;
    input  SCD ;
    input  SCE ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    reg Q;

    always @(posedge CLK) begin
        if (SCD == 1) begin
            Q <= 0;
        end else if (SCE == 0) begin
            Q <= Q;
        end else begin
            Q <= D;
        end
    end

endmodule