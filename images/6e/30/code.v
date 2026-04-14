module top_module(
    input  D,
    output Q,
    input  RESET,
    input  SET,
    input  CLK_N
);reg Q_reg;

always @ (negedge CLK_N) begin
    if (RESET) begin
        Q_reg <= 0;
    end else if (SET) begin
        Q_reg <= 1;
    end else begin
        Q_reg <= D;
    end
end

assign Q = Q_reg;

endmodule