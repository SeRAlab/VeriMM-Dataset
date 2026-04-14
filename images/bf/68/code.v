module top_module(
    Q      ,
    CLK_N  ,
    D      ,
    RESET_B
);output Q      ;
    input  CLK_N  ;
    input  D      ;
    input  RESET_B;

    reg Q;

    always @ (posedge CLK_N or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 0;
        end else begin
            if (D) begin
                Q <= 1;
            end
        end
    end

endmodule