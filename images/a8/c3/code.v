module top_module(
    RESET_B,
    CLK    ,
    D      ,
    Q      ,
    Q_N    ,
    VPWR   ,
    VGND
);input  RESET_B;
    input  CLK    ;
    input  D      ;
    output Q      ;
    output Q_N    ;
    input  VPWR   ;
    input  VGND   ;
    
    reg Q_int;

    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) begin
            Q_int <= 1'b0;
        end else begin
            Q_int <= D;
        end
    end
    
    assign Q = Q_int;
    assign Q_N = ~Q_int;
    
endmodule