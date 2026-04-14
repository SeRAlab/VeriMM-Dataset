module top_module(
    //# {{data|Data Signals}}
    input  D      ,
    output Q      ,
    output Q_N    ,

    //# {{control|Control Signals}}
    input  RESET_B,

    //# {{clocks|Clocking}}
    input  GATE_N ,

    //# {{power|Power}}
    input  VPB    ,
    input  VPWR   ,
    input  VGND   ,
    input  VNB
);reg Q_reg, Q_N_reg;
    
    always @(posedge GATE_N) begin
        if(RESET_B == 0) begin
            Q_reg <= 0;
            Q_N_reg <= 1;
        end
        else begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end
    
    assign Q = Q_reg;
    assign Q_N = Q_N_reg;
    
endmodule