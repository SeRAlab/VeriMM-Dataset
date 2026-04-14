module top_module(
    Q    ,
    Q_N  ,
    CLK  ,
    D    ,
    SCD  ,
    SCE  ,
    ASYNC
);output Q    ;
    output Q_N  ;
    input  CLK  ;
    input  D    ;
    input  SCD  ;
    input  SCE  ;
    input  ASYNC;

    reg Q;
    wire Q_N;

    assign Q_N = ~Q;

    always @(posedge CLK or posedge ASYNC) begin
        if (ASYNC) begin
            Q <= 0;
        end else if (SCD) begin
            Q <= 1;
        end else if (SCE) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule