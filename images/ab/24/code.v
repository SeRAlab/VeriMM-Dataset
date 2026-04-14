module top_module(
    input D,
    input CLK,
    input SET,
    input RESET,
    output Q,
    output Q_N
);reg Q_reg, Q_N_reg;

always @(posedge CLK or posedge RESET or posedge SET)
begin
    if (RESET)
    begin
        Q_reg <= 1'b0;
        Q_N_reg <= 1'b1;
    end
    else if (SET)
    begin
        Q_reg <= 1'b1;
        Q_N_reg <= 1'b0;
    end
    else
    begin
        Q_reg <= D;
        Q_N_reg <= ~D;
    end
end

assign Q = Q_reg;
assign Q_N = Q_N_reg;

endmodule