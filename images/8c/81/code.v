module top_module(
    //# {{data|Data Signals}}
    input  D   ,
    output Q   ,

    //# {{clocks|Clocking}}
    input  GATE,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);reg Q_reg;

    always @(posedge GATE) begin
        Q_reg <= D;
    end

    assign Q = Q_reg;

endmodule