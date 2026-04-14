module top_module(
    Q   ,
    Q_N ,
    D   ,
    GATE,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Q   ;
    output Q_N ;
    input  D   ;
    input  GATE;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    reg Q_int;
    
    assign Q = Q_int;
    assign Q_N = ~Q_int;
    
    always @ (D, GATE)
    begin
        if (GATE == 1'b0)
        begin
            Q_int <= Q_int;
        end
        else
        begin
            Q_int <= D;
        end
    end

endmodule