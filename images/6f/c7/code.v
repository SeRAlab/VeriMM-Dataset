module top_module(
    Q      ,
    Q_N    ,
    D      ,
    SCD    ,
    SCE    ,
    CLK    ,
    SET_B  ,
    RESET_B
);output Q      ;
    output Q_N    ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  CLK    ;
    input  SET_B  ;
    input  RESET_B;

    reg Q;
    wire Q_N;

    assign Q_N = ~Q;

    always @(posedge CLK) begin
        if (RESET_B) begin
            Q <= 0;
        end else if (SET_B) begin
            Q <= 1;
        end else if (SCD) begin
            Q <= 0;
        end else if (SCE) begin
            Q <= 1;
        end else begin
            if (SCE) begin
                Q <= ~D;
            end else if (SCD) begin
                Q <= 1;
            end else if (SCE) begin
                Q <= 0;
            end else begin
                Q <= D;
            end
        end
    end

endmodule