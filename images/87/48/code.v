module top_module(
    Q       ,
    D       ,
    CLK     ,
    SLEEP_B ,
    NOTIFIER,
    KAPWR   ,
    VGND    ,
    VPWR    ,
    RST_B   ,
    EN
);output Q       ;
    input  D       ;
    input  CLK     ;
    input  SLEEP_B ;
    input  NOTIFIER;
    input  KAPWR   ;
    input  VGND    ;
    input  VPWR    ;
    input  RST_B   ;
    input  EN      ;
    
    reg Q;
    reg Q_next;
    
    always @(posedge CLK or negedge RST_B) begin
        if (~RST_B) begin
            Q <= 0;
        end else if (EN) begin
            Q <= Q_next;
        end
    end
    
    always @(D) begin
        Q_next <= D;
    end

endmodule