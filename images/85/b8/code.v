module top_module(
    Q   ,
    CLK ,
    D   ,
    DE  ,
    SCD ,
    SCE ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Q   ;
    input  CLK ;
    input  D   ;
    input  DE  ;
    input  SCD ;
    input  SCE ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Scan chain enable/disable
    wire scan_en = SCE & ~SCD;

    // D flip-flop
    reg Q_reg;
    always @(posedge CLK) begin
        if (scan_en & DE) begin
            Q_reg <= D;
        end
    end

    // Output
    assign Q = scan_en ? Q_reg : 1'b0;

    // Power and ground connections
    assign VPWR = 1'b1;
    assign VGND = 1'b0;
    assign VPB = 1'b1;
    assign VNB = 1'b0;

endmodule