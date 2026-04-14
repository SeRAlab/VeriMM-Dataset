module top_module(
    //# {{data|Data Signals}}
    input  D   ,
    output Q   ,

    //# {{clocks|Clocking}}
    input  CLK ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);reg Q_reg;

    always @(posedge CLK)
        Q_reg <= D;
    
    assign Q = Q_reg;

endmodule