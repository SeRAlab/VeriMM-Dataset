module top_module(
           IN_H         ,
           PAD_A_NOESD_H,
           PAD          ,
           DM           ,
           HLD_H_N      ,
           INP_DIS      ,
           IN           ,
           ENABLE_H     ,
           OE_N         ,
           SLOW         ,
           VTRIP_SEL    ,
           VINREF       ,
           VOUTREF      ,
           VREG_EN      ,
           IBUF_SEL     ,
           REFLEAK_BIAS ,
           PAD_A_ESD_0_H,
           TIE_LO_ESD   ,
           HLD_OVR      ,
           OUT          ,
           PAD_A_ESD_1_H,
           VSSIO        ,
           VSSIO_Q      ,
           VSSD         ,
           VCCD         ,
           VDDIO        ,
           VCCHIB       ,
           VDDIO_Q
       );input        HLD_H_N      ;
input        INP_DIS      ;
input        ENABLE_H     ;
input        OE_N         ;
input        SLOW         ;
input        VTRIP_SEL    ;
input        VINREF       ;
input        VOUTREF      ;
input        VREG_EN      ;
input        IBUF_SEL     ;
input        REFLEAK_BIAS ;
input        HLD_OVR      ;
input        OUT          ;
output       IN_H         ;
output       IN           ;
output       TIE_LO_ESD   ;
inout        PAD_A_NOESD_H;
inout        PAD          ;
inout        PAD_A_ESD_0_H;
inout        PAD_A_ESD_1_H;
inout        VSSIO        ;
inout        VSSIO_Q      ;
inout        VSSD         ;
inout        VCCD         ;
inout        VDDIO        ;
inout        VCCHIB       ;
inout        VDDIO_Q      ;
input  [2:0] DM           ;

reg [2:0] dm_reg;

assign IN_H = 1'b0;
assign IN = (ENABLE_H == 1'b0 && INP_DIS == 1'b0 && HLD_H_N == 1'b1) ? 1'b1 : 1'b0;
assign TIE_LO_ESD = (REFLEAK_BIAS == 1'b0 && HLD_OVR == 1'b1) ? 1'b0 : 1'bx;

always @ (posedge SLOW or posedge SLOW) begin
    if (SLOW == 1'b0) begin
        dm_reg <= DM;
    end else begin
        dm_reg <= {DM[1], DM[2], DM[0]};
    end
end

assign PAD_A_NOESD_H = (OE_N == 1'b0) ? PAD_A_NOESD_H : 1'bz;
assign PAD = (OE_N == 1'b0) ? PAD : 1'bz;

endmodule