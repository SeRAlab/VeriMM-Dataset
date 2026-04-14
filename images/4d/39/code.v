module top_module(
    Q      ,
    CLK    ,
    D      ,
    RESET  ,
    SET
);output Q      ;
    input  CLK    ;
    input  D      ;
    input  RESET  ;
    input  SET    ;

    reg Q;

    always @(posedge CLK or posedge RESET or posedge SET) begin
        if (RESET) begin
            Q <= 0;
        end else if (SET) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule