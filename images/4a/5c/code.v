module top_module(
    input  D      ,
    output Q      ,
    input  RESET_B,
    input  CLK    ,
    input  EN     ,
    input  SEL
);reg Q_reg;

    always @(posedge CLK) begin
        if (RESET_B == 0) begin
            Q_reg <= 0;
        end else if (EN == 1) begin
            if (SEL == 1) begin
                Q_reg <= D;
            end else begin
                Q_reg <= ~D;
            end
        end
    end

    assign Q = Q_reg;

endmodule